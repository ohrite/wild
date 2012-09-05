$: << File.expand_path('../../lib', __FILE__)

require 'pry'
require 'rspec'
require 'wild'

Dir.glob(File.expand_path('../contexts/**/*.rb', __FILE__)).each do |context|
  require context
end
