# frozen_string_literal: true

require 'nokogiri'

class ResultsExtractor
  include Nokogiri

  def initialize(noko_doc)
    @noko_doc = noko_doc
  end

  def extract_results(runner_name)
    row = @noko_doc.css("table.Results-table tbody tr").find do |tr|
      tr["data-name"]&.casecmp?(runner_name)
    end
    partial_result = { name: runner_name, competed: false, cancelled: false }
    return partial_result unless row
    
    partial_result.merge!({ competed: true,
                            position: row.at_css("td.Results-table-td--position")&.text&.strip,
                            time: row.at_css("td.Results-table-td--time div")&.text&.strip
                          })          
  end
end
