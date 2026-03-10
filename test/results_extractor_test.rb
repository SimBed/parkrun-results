require_relative 'test_helper'
require 'results_extractor'
require 'nokogiri'

class ResultsExtractorTest < Minitest::Test
  def setup
    @html_runner_didnt_compete = <<-HTML
      <table class="Results-table">
        <tbody>
          <tr data-name="Someone Else"></tr>
        </tbody>
      </table>
    HTML

    @html_runner_competed = <<-HTML
      <table class="Results-table">
        <tbody>
          <tr data-name="Alice Example">
            <td class="Results-table-td--position">42</td>
            <td class="Results-table-td--time">
              <div>23:45</div>
            </td>
          </tr>
        </tbody>
      </table>
    HTML

  end

  def test_extract_results_when_runner_did_not_compete
    doc = Nokogiri::HTML(@html_runner_didnt_compete)
    extractor = ResultsExtractor.new(doc)

    result = extractor.extract_results('Missing Runner')

    assert_equal({ name: 'Missing Runner', competed: false, cancelled: false }, result)
  end

  def test_extract_results_when_runner_did_compete
    doc = Nokogiri::HTML(@html_runner_competed)
    extractor = ResultsExtractor.new(doc)

    result = extractor.extract_results('Alice Example')

    assert_equal 'Alice Example', result[:name]
    assert_equal true, result[:competed]
    assert_equal false, result[:cancelled]
    assert_equal '42', result[:position]
    assert_equal '23:45', result[:time]
  end
end

