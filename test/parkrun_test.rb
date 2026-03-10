require_relative 'test_helper'
require 'parkrun'

class ParkrunTest < Minitest::Test
  def setup
    @parkrun = Parkrun.new('ferry meadows', '2026-02-28')
  end
  def test_latest_result_page
    expected = 'https://www.parkrun.org.uk/ferrymeadows/results/2026-02-28/'
    assert_equal expected, @parkrun.latest_result_page
  end
  def test_homepage
    assert_equal 'https://www.parkrun.org.uk/ferrymeadows/', @parkrun.homepage
  end

  def test_formal_name
    assert_equal 'Ferry Meadows', @parkrun.formal_name
  end


end

