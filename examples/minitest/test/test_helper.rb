# frozen_string_literal: true

require 'minitest/autorun'
require 'test_map' # if ENV['TEST_MAP']

require_relative '../animal'
require_relative '../cat'
require_relative '../dog'

# Output log messages to the console on demand.
TestMap::Config.configure do |config|
  config[:logger] = Logger.new($stdout, level: :info)
end

# Run tests with `ruby -Itest test/*_test.rb`.
