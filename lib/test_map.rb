# frozen_string_literal: true

require_relative 'test_map/config'
require_relative 'test_map/version'
require_relative 'test_map/errors'
require_relative 'test_map/filter'
require_relative 'test_map/report'
require_relative 'test_map/file_recorder'
require_relative 'test_map/natural_mapping'
require_relative 'test_map/mapping'
require_relative 'test_map/cache'
require_relative 'test_map/event'

# TestMap records associated files to test execution.
module TestMap
  def self.reporter = @reporter ||= Report.new
  def self.logger = Config.config[:logger]

  def self.cache
    @cache ||= Cache.new(
      File.join(Dir.pwd, Config[:cache_file]),
      File.join(Dir.pwd, Config[:out_file])
    )
  end

  def self.reset!
    @reporter = nil
    @cache = nil
    Config.reset!
  end

  class << self
    attr_accessor :suite_passed

    def write_results
      out_file = File.join(Dir.pwd, Config.config[:out_file])
      full_results = reporter.write(out_file)

      # All tests were cache-skipped or nothing recorded, existing files are still valid
      return unless full_results

      cache.write(full_results) if suite_passed
    end
  end
end

# Load plugins for supported test frameworks.
require_relative 'test_map/plugins/minitest' if defined?(Minitest)
require_relative 'test_map/plugins/rspec' if defined?(RSpec)
