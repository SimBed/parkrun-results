require_relative 'test_helper'
require 'notifier'

class NotifierTest < Minitest::Test
  class FakeChannel
    attr_reader :delivered

    def initialize
      @delivered = []
    end

    def deliver(date, results, results_all_in)
      @delivered << [date, results, results_all_in]
    end
  end

  def test_notifies_all_channels
    channel1 = FakeChannel.new
    channel2 = FakeChannel.new
    notifier = Notifier.new([channel1, channel2])

    date = '2026-02-28'
    results = [{ name: 'Alice Example' }]
    results_all_in = true

    notifier.notify(date, results, results_all_in)

    assert_equal [[date, results, results_all_in]], channel1.delivered
    assert_equal [[date, results, results_all_in]], channel2.delivered
  end
end

