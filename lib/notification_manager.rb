require "date"
require_relative '../lib/email_notifier'
require_relative '../lib/notifier'

class NotificationManager

  def initialize(date, results, results_all_in)
    @date = date
    @results = results
    @results_all_in = results_all_in
    channels = []
    channels << EmailNotifier.new if ENV['EMAIL_ENABLED'] == 'true'
    @notifier = Notifier.new(channels)
  end

  def run
    issue_results
  end

  private

  def issue_results
    @notifier.notify(@date, @results, @results_all_in)
  end
end