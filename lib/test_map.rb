# frozen_string_literal: true

require_relative 'test_map/version'
require_relative 'test_map/errors'
require_relative 'test_map/report'
require_relative 'test_map/file_recorder'

# TestMap records associated files to test execution.
module TestMap
  def self.reporter = @reporter ||= Report.new
end
