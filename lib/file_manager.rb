# frozen_string_literal: true

module FileManager
  PROJECT_ROOT = File.expand_path('..', __dir__) # /home/..../parkrun
  RESULTS_DIR = File.join(PROJECT_ROOT, 'results') # /home/...../parkrun/results
  
  def results_file_path(park_name, date, cancelled: false)
    extension = cancelled ? "cancelled" : "html"
    File.join(RESULTS_DIR, "#{results_file_name(park_name, date)}.#{extension}") # "/home/..../results/cassiobury-2026-02-28.html[cancelled]"
  end

  def results_file_name(park_name, date)
    "#{park_name}-#{date}" # "cassiobury-2026-02-28"
  end

  def notification_sent_file_path(date, final: false)
    # /home/..../parkrun/results/last[or final]-notification-2026-02-28.sent
    File.join(RESULTS_DIR, "#{notification_sent_file_name(date, final: final)}.sent") 
  end

  def notification_sent_file_name(date, final: false)
    prefix = final ? "final" : "last"
    # "last-notification-2026-02-28" or "final-notification-2026-02-28"    
    "#{prefix}-notification-#{date}"
  end
end
