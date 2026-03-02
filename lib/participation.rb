class Participation
  attr_reader :runner_name, :parkrun
  def initialize(attributes = {}, date)
    @runner_name = attributes["runner_name"]
    @parkrun = Parkrun.new(attributes["park_name"], date) 
  end
end