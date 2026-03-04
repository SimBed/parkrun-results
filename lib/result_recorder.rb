# frozen_string_literal: false

require_relative 'file_manager'

class ResultRecorder
  include FileManager

  def initialize(date)
    @date = date
  end

  def already_recorded?(parkrun_name)
    File.exist?(results_file_path(parkrun_name, @date)) || File.exist?(results_file_path(parkrun_name, @date, cancelled: true))
  end

  def cancelled?(parkrun_name)
    File.exist?(results_file_path(parkrun_name, @date, cancelled: true))
  end

  def record_result(parkrun_name, response_body)
    File.write(results_file_path(parkrun_name, @date), response_body)
  end

  def record_cancellation(parkrun_name)
    File.write(results_file_path(parkrun_name, @date, cancelled: true), "cancelled")
  end

end
