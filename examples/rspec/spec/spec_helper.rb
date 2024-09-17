# frozen_string_literal: true

require 'test_map' # if ENV['TEST_MAP']

require_relative '../animal'
require_relative '../cat'
require_relative '../dog'

# Output log messages to the console on demand.
TestMap::Config.configure do |config|
  config[:logger] = Logger.new($stdout, level: :info)
end

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
# RSpec.configure do |config|
# end
