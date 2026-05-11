# frozen_string_literal: true

module TestMap
  # CachedSkip is raised to skip tests whose files haven't changed.
  # Subclasses Minitest::Skip so Minitest treats it as a skip, but the
  # custom reporter can distinguish it and show `C` instead of `S`.
  class CachedSkip < Minitest::Skip
    def initialize(msg = 'test-map: cached')
      super
    end

    def result_label
      'Cached'
    end
  end
end

require_relative 'minitest/cache_reporter'

module TestMap
  module Plugins
    # Minitest plugin for TestMap.
    module Minitest
      def self.included(_base)
        TestMap.logger.info 'Registering hooks for Minitest'
        TestMap.suite_passed = true

        ::Minitest.after_run { write_results }
        install_cache_reporter
      end

      def self.install_cache_reporter
        ::Minitest.extensions << 'test_map_cache'
      end

      def self.write_results
        out_file = "#{Dir.pwd}/#{Config.config[:out_file]}"
        full_results = TestMap.reporter.write(out_file)

        # All tests were cache-skipped or nothing recorded, existing files are still valid
        return unless full_results

        TestMap.cache.write(full_results) if TestMap.suite_passed
      end

      def before_setup
        test_file = resolve_test_file
        raise TestMap::CachedSkip if test_file && TestMap.cache.fresh?(test_file)

        @recorder = FileRecorder.new.tap(&:trace)
        super
      end

      def before_teardown
        super

        return unless @recorder

        @recorder.stop
        TestMap.reporter.add @recorder.results

        TestMap.suite_passed = false if !passed? && !skipped?
      end

      private

      def resolve_test_file
        file = method(name).source_location&.first
        return unless file

        file.sub("#{Dir.pwd}/", '')
      end
    end
  end
end

TestMap.logger.info 'Loading Minitest plugin'

if defined?(Rails)
  ActiveSupport::TestCase.include TestMap::Plugins::Minitest
else
  Minitest::Test.include TestMap::Plugins::Minitest
end
