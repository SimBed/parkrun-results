# frozen_string_literal: true

class Notifier
  def initialize(channels)
    @channels = channels
  end

  def notify(date, results, results_all_in)
    @channels.each { |channel| channel.deliver(date, results, results_all_in) }
  end
end
