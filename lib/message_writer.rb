class MessageWriter
  def initialize(results)
    @results = results
  end

  def write_message
    return "No participations this week" if @results.empty?

    @results.map { |result| write_line(result) }.join("\n")
  end

  private
  def write_line(result)
    if result[:cancelled]
      <<~RESULT
        Name: #{result[:name]}
        Parkrun: #{result[:parkrun_name]}
        Parkrun was cancelled this week
      RESULT
    elsif result[:competed]
      <<~RESULT
        Name: #{result[:name]}
        Parkrun: #{result[:parkrun_name]}
        Time: #{result[:time]}
        Position: #{result[:position]}
      RESULT
    else
      <<~RESULT
        Name: #{result[:name]}
        Parkrun: #{result[:parkrun_name]}
        Did not compete this week
      RESULT
    end
  end
end
