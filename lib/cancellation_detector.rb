# frozen_string_literal: false

require_relative 'website_requester'

class CancellationDetector
  def initialize(parkrun)
    @homepage = parkrun.homepage
    cancellation_words = ENV.fetch('CANCELLATION_WORDS', '')
                            .split(',')
                            .map(&:strip)
                            .reject(&:empty?)
    # the (?:..) is a non-capturing group that matches any of the cancellation words
    # \b is word boundary
    @regexs = /\b(?:#{cancellation_words.join('|')})\b/i    
  end

  def run
    response_body = WebsiteRequester.new(@homepage).request
    noko_doc = Nokogiri::HTML(response_body)
    noko_doc.css('h1, h2, h3, h4, h5, h6').find { |h| h.text.match?(@regexs) }
  end

end
