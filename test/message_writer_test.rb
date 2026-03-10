require_relative 'test_helper'
require 'message_writer'

class MessageWriterTest < Minitest::Test

  def setup
    @results = [
      {
        name: 'Alice Example',
        parkrun_name: 'Ferry Meadows',
        cancelled: true,
        competed: false
      },
      {
        name: 'Bob Runner',
        parkrun_name: 'Huntingdon',
        cancelled: false,
        competed: true,
        time: '21:10',
        position: '15'
      },
      {
        name: 'Carla Walker',
        parkrun_name: 'Cassiobury',
        cancelled: false,
        competed: false
      }
    ]
  end
  def test_write_message_when_no_results
    writer = MessageWriter.new([])
    assert_equal 'No participations this week', writer.write_message
  end
  
  def test_write_message_when_cancelled

    writer = MessageWriter.new(@results)
    
    result_text = <<~RESULT
        Name: Alice Example
        Parkrun: Ferry Meadows
        Parkrun was cancelled this week\n
        Name: Bob Runner
        Parkrun: Huntingdon
        Time: 21:10
        Position: 15\n
        Name: Carla Walker
        Parkrun: Cassiobury
        Did not compete this week
      RESULT
    assert_equal result_text, writer.write_message
  end

end

