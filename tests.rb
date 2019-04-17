puts
Dir.glob('bowling/test/*_test.rb') do |f|
  puts "running #{f}"
  require_relative("../#{f}")
end
