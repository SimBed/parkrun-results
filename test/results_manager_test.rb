require_relative 'test_helper'
require 'results_manager'

class ResultsManagerTest < Minitest::Test
  class FakeResultRecorder
    attr_reader :recorded_results, :recorded_cancellations

    def initialize(date)
      @date = date
      @already_recorded = {}
      @recorded_results = []
      @recorded_cancellations = []
    end

    def already_recorded?(parkrun_codename)
      @already_recorded.fetch(parkrun_codename, false)
    end

    def cancelled?(_parkrun_codename)
      false
    end

    def record_result(parkrun_codename, response_body)
      @recorded_results << [parkrun_codename, response_body]
      @already_recorded[parkrun_codename] = true
    end

    def record_cancellation(parkrun_codename)
      @recorded_cancellations << parkrun_codename
      @already_recorded[parkrun_codename] = true
    end
  end

  class FakeWebsiteRequester
    attr_reader :url

    def self.requested_urls
      @requested_urls ||= []
    end

    def initialize(url)
      @url = url
    end

    def request
      self.class.requested_urls << url
      'fake response'
    end
  end

  class FakeCancellationDetector
    def initialize(_parkrun); end

    def run
      false
    end
  end

  def setup
    @original_result_recorder = Object.const_get(:ResultRecorder)
    @original_website_requester = Object.const_get(:WebsiteRequester)
    @original_cancellation_detector = Object.const_get(:CancellationDetector)

    Object.send(:remove_const, :ResultRecorder)
    Object.send(:remove_const, :WebsiteRequester)
    Object.send(:remove_const, :CancellationDetector)

    Object.const_set(:ResultRecorder, FakeResultRecorder)
    Object.const_set(:WebsiteRequester, FakeWebsiteRequester)
    Object.const_set(:CancellationDetector, FakeCancellationDetector)
  end

  def teardown
    Object.send(:remove_const, :ResultRecorder)
    Object.send(:remove_const, :WebsiteRequester)
    Object.send(:remove_const, :CancellationDetector)

    Object.const_set(:ResultRecorder, @original_result_recorder)
    Object.const_set(:WebsiteRequester, @original_website_requester)
    Object.const_set(:CancellationDetector, @original_cancellation_detector)
  end

  def test_record_raw_data_records_unrecorded_parkruns_and_sets_flags
    date = '2026-02-28'
    participations = [
      { 'runner_name' => 'Alice Example', 'park_name' => 'ferry meadows' }
    ]

    manager = ResultsManager.new(participations, date)

    manager.record_raw_data

    recorder = manager.instance_variable_get(:@result_recorder)
    assert_equal [['ferrymeadows', 'fake response']], recorder.recorded_results
    assert_equal true, manager.notifiable_change
    assert_equal true, manager.results_all_in
  end
end

