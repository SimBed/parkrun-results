# frozen_string_literal: false

require_relative 'file_manager'

class StateRecorder
  include FileManager

  def initialize(date)
    @date = date
  end
  
  # def final_notification_sent?
  #   File.exist?(notification_sent_file_path(@date, final: true))
  # end
  
  def notification_sent_recently?(delay_in_minutes: 60)
    path = notification_sent_file_path(@date)
    return false unless File.exist?(path)
    
    time_last_notified = Time.parse(File.read(path))
    Time.now - time_last_notified < delay_in_minutes * 60
  end

  def ok_to_send_notification?(minimum_delay: 60)
    return true unless final_notification_sent? || notification_sent_recently?(minimum_delay)
  end
  
  def record_time_last_notification_sent
    File.write(notifications_sent_file_path(@date), Time.now.to_s)
  end
  
  def record_final_notification_sent
    # File.write("data/meta/final_sent.flag", "done")
    File.write(final_notification_sent_file_path(@date), 'done')
  end
  
  # def record_notifications_sent
  #   File.write(notifications_sent_file_path(@date), Time.now.to_s)
  # end
  
  # def notifications_already_sent?
  #   File.exist?(notifications_sent_file_path(@date))
  # end
end
