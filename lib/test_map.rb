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

# Load Minitest plugin if Minitest is defined.
require_relative 'test_map/minitest/plugin' if defined?(Minitest)
