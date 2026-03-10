require_relative 'test_helper'
require 'parkrun'
require 'participation'

class ParticipationTest < Minitest::Test
  def test_initializes_runner_name_and_parkrun
    date = '2026-02-28'
    attributes = { 'runner_name' => 'Alice Example', 'park_name' => 'ferry meadows' }

    participation = Participation.new(attributes, date)

    assert_equal 'Alice Example', participation.runner_name
    assert participation.parkrun.is_a?(Parkrun)
  end
end

