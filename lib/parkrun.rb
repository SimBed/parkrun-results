require 'active_support/core_ext/string/inflections'
class Parkrun

  def initialize(name, date)
    @name = name
    @date = date
  end

  def latest_result_page
    # /latestresults endpoint returns javascript which fetches from the yyyy-mm-dd endpoint.
    # /latestresults doesnt itself include the data we need.
    "https://www.parkrun.org.uk/#{code_name}/results/#{@date}/"
  end

  def homepage
    "https://www.parkrun.org.uk/#{code_name}/"
  end

  def code_name
    @name.split(' ').join.downcase
  end

  def formal_name
    @name.titleize
  end
end