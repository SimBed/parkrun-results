require_relative 'test_helper'
require 'file_manager'

class FileManagerTest < Minitest::Test
  class Dummy
    include FileManager
  end

  def setup
    @dummy = Dummy.new
  end

  def test_results_file_name
    name = 'cassiobury'
    date = '2026-02-28'

    assert_equal 'cassiobury-2026-02-28', @dummy.results_file_name(name, date)
  end

  def test_results_file_path
    name = 'cassiobury'
    date = '2026-02-28'

    path = @dummy.results_file_path(name, date)
    assert path.end_with?('/results/cassiobury-2026-02-28.html')
    
    path = @dummy.results_file_path(name, date, cancelled: true)
    assert path.end_with?('/results/cassiobury-2026-02-28.cancelled')
  end


  def test_notification_sent_file_name_default_prefix_last
    date = '2026-02-28'

    assert_equal 'last-notification-2026-02-28',
                 @dummy.notification_sent_file_name(date)
    assert_equal 'final-notification-2026-02-28',
                 @dummy.notification_sent_file_name(date, final: true)
  end

end

