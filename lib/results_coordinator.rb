# frozen_string_literal: false

require_relative 'website_requester'
require_relative 'results_extractor'
require_relative 'participation'
require_relative 'parkrun'
require_relative 'result_recorder'
require_relative 'notifier'
require_relative 'email_notifier'

class ResultsCoordinator
  include FileManager
  attr_reader :results

  def initialize(participations, date, notifier)
    @date = date
    @participations = participations.map { |participation| Participation.new(participation, @date) }
    @notifier = notifier
    park_name_codes = @participations.map { |participation| participation.parkrun.code_name }.uniq
    @result_recorder = ResultRecorder.new(@date)
    @parkruns_unrecorded = park_name_codes.reject { |park_name_code| @result_recorder.already_recorded?(park_name_code) }
                                          .map { |park_name_code| Parkrun.new(park_name_code, @date) }
    @results = []
  end

  def record_raw_data
    @parkruns_unrecorded.each do |parkrun|
      response = WebsiteRequester.new(parkrun.url_latest_result).request
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
      noko_doc = File.open(results_file_path(parkrun.code_name, @date)) { |f| Nokogiri::HTML(f) }
      result = ResultsExtractor.new(noko_doc).extract_results(participation.runner_name)
      result.merge!({date: @date, parkrun_name: parkrun.formal_name})
      @results << result
    end
  end

  def manage_notifications
    issue_results
    record_results_issued
  end

  private

  def issue_results
    @notifier.notify(@date, @results)
  end

  def record_results_issued
    StateRecorder.new(@date).record_notifications_sent
  end
end
