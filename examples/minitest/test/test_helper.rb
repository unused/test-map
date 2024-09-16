# frozen_string_literal: true

require 'minitest/autorun'
require 'test_map'
require 'test_map/minitest/plugin'

require_relative '../animal'
require_relative '../cat'
require_relative '../dog'

# TestMap::Config.configure do |config|
#   config[:logger] = Logger.new($stdout, level: :info)
# end

module Minitest
  # Patch minitest base test class.
  class Test
    include TestMap::Minitest::Plugin
  end
end

# Run tests with `ruby -Itest test/*_test.rb`.
