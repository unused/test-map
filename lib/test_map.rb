# frozen_string_literal: true

require_relative 'test_map/config'
require_relative 'test_map/version'
require_relative 'test_map/errors'
require_relative 'test_map/report'
require_relative 'test_map/file_recorder'

# TestMap records associated files to test execution.
module TestMap
  def self.reporter = @reporter ||= Report.new
  def self.logger = Config.config[:logger]
end

# Load plugins for supported test frameworks.
require_relative 'test_map/plugins/minitest' if defined?(Minitest)
require_relative 'test_map/plugins/rspec' if defined?(RSpec)
