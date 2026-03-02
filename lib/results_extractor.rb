# frozen_string_literal: true

require 'nokogiri'

class ResultsExtractor
  include Nokogiri

  def initialize(noko_doc)
    @noko_doc = noko_doc
  end

  def extract_results(full_name)
    row = @noko_doc.css("table.Results-table tbody tr").find do |tr|
      tr["data-name"]&.casecmp?(full_name)
    end
    return { name: full_name, competed: false} unless row
    
    {
      name: full_name,
      competed: true,
      position: row.at_css("td.Results-table-td--position")&.text&.strip,
      time: row.at_css("td.Results-table-td--time div")&.text&.strip
    }
  end
end
