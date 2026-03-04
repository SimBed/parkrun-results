# frozen_string_literal: false

require_relative 'cancellation_detector'
require_relative 'email_notifier'
require_relative 'notifier'
require_relative 'parkrun'
require_relative 'participation'
require_relative 'results_extractor'
require_relative 'result_recorder'
require_relative 'website_requester'

class ResultsCoordinator
  include FileManager
  attr_reader :results

  def initialize(participations, date, notifier)
    @date = date
    @participations = participations.map { |participation| Participation.new(participation, @date) }
    @notifier = notifier
    parkrun_codenames = @participations.map { |participation| participation.parkrun.code_name }.uniq
    @result_recorder = ResultRecorder.new(@date)
    @parkruns_unrecorded = parkrun_codenames.reject { |parkrun_codename| @result_recorder.already_recorded?(parkrun_codename) }
                                            .map { |parkrun_codename| Parkrun.new(parkrun_codename, @date) }
    @results = []
  end

  def record_raw_data
    @parkruns_unrecorded.each do |parkrun|
      next if cancellation?(parkrun)
      response = WebsiteRequester.new(parkrun.latest_result_page).request
      if response
        @result_recorder.record_result(parkrun.code_name, response)
        puts "Results recorded for #{parkrun.code_name} at #{@date}"
      end
    end
    @parkruns_unrecorded.reject! { |parkrun| @result_recorder.already_recorded?(parkrun.code_name) }
  end

  def results_all_in?
    @parkruns_unrecorded.empty?
  end

  def process_results
    @participations.each do |participation|
      parkrun = participation.parkrun
      result_recorder = ResultRecorder.new(@date)
      if result_recorder.cancelled?(parkrun.code_name)
        result = { name: participation.runner_name, competed: false, cancelled: true}        
      else
        noko_doc = File.open(results_file_path(parkrun.code_name, @date)) { |f| Nokogiri::HTML(f) }
        result = ResultsExtractor.new(noko_doc).extract_results(participation.runner_name)
      end
      result.merge!({date: @date, parkrun_name: parkrun.formal_name})
      @results << result
    end
  end

  def manage_notifications
    issue_results
    record_results_issued
  end

  private

  def cancellation?(parkrun)
    cancellation = CancellationDetector.new(parkrun).run
    @result_recorder.record_cancellation(parkrun.code_name) if cancellation
    cancellation # returns a boolean value, so we can use it directly with next in the block
  end

  def issue_results
    @notifier.notify(@date, @results)
  end

  def record_results_issued
    StateRecorder.new(@date).record_notifications_sent
  end
end
