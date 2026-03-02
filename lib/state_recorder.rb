# frozen_string_literal: false

require_relative 'file_manager'

class StateRecorder
  include FileManager

  def initialize(date)
    @date = date
  end

  def record_notifications_sent
    File.write(notifications_sent_file_path(@date), Time.now.to_s)
  end

  def notifications_already_sent?
    File.exist?(notifications_sent_file_path(@date))
  end

end
