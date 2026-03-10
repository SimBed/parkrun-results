# equivalent to:
# $ruby -Itest -e 'Dir["test/*_test.rb"].sort.each { |f| require_relative f }'

# run with $rake test
require 'rake/testtask'

Rake::TestTask.new do |t|
  # this clean approach works but on test failure gives a much less clean output than the dirty bash command approach  
  # t.libs << 'test'
  # t.pattern = 'test/*_test.rb'
  # t.verbose = true
  cmd = %q{ruby -Itest -e 'Dir["test/*_test.rb"].sort.each { |f| require_relative f }'}
  system(cmd)
  exit($?.exitstatus || 0)
end

# task default: :test
