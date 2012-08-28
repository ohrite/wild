$: << File.expand_path('../../lib/wild', __FILE__)

require 'rspec'
require 'wild'

Dir.glob(File.expand_path('../contexts/**/*.rb', __FILE__)).each do |context|
  require context
end

RSpec.configure do |c|
end
