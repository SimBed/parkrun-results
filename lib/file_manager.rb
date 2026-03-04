# frozen_string_literal: true

module FileManager
  PROJECT_ROOT = File.expand_path('..', __dir__) # /home/..../parkrun
  RESULTS_DIR = File.join(PROJECT_ROOT, 'results') # /home/...../parkrun/results
  
  def results_file_path(park_name, date, cancelled: false)
    extension = cancelled ? "cancelled" : "html"
    File.join(RESULTS_DIR, "#{results_file_name(park_name, date)}.#{extension}") # /home/..../parkrun/results/"cassiobury-2026-02-28.html" or "cassiobury-2026-02-28.cancelled"
  end

  def results_file_name(park_name, date)
    "#{park_name}-#{date}" # "cassiobury-2026-02-28"
  end

  def notifications_sent_file_path(date)
    File.join(RESULTS_DIR, "#{notifications_sent_file_name(date)}.sent") # /home/..../parkrun/results/notifications-2026-02-28.sent
  end

  def notifications_sent_file_name(date)
    "notifications-#{date}" # "notifications-2026-02-28"
  end
end
