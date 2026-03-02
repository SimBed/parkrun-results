# frozen_string_literal: false

require 'net/http'
require 'nokogiri'
require 'openssl'

# the site needs to be convinced the reaquest is not coming from a bot, so we need to include headers that a normal browser would send.
# the complicated looking user-agent value is actually just the default user-agent string from a Chrome browser on Windows 10
# (see the the request headers in inspector)
HEADERS = {
  'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)' \
                  'Chrome/121.0 Safari/537.36',
  'Accept' => 'text/html',
  'Accept-Language' => 'en-US,en;q=0.9',
  'Connection' => 'keep-alive',
  'Upgrade-Insecure-Requests' => '1'
}.freeze

class WebsiteRequester
  def initialize(url)
    @uri = URI.parse(url)
  end

  def request
    response = Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new(@uri, HEADERS)
      http.request(req)
    end
    return nil unless response.is_a?(Net::HTTPSuccess)

    response.body
  rescue StandardError => e
    warn "Request failed: #{e}"
    exit 1
  end
end
