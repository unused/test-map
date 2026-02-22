# frozen_string_literal: true

module TestMap
  module Plugins
    # Minitest plugin for TestMap.
    module Minitest
      def self.included(_base)
        TestMap.logger.info 'Registering hooks for Minitest'
        TestMap.suite_passed = true

        ::Minitest.after_run { write_results }
      end

      def self.write_results
        out_file = "#{Dir.pwd}/#{Config.config[:out_file]}"
        reporter_results = TestMap.reporter.results

        # All tests were cache-skipped, existing files are still valid
        return if reporter_results.empty?

        full_results = merge_results(out_file, reporter_results)
        File.write(out_file, full_results.to_yaml)
        TestMap.cache.write(full_results) if TestMap.suite_passed
      end

      # Merge with existing map to preserve mappings for cache-skipped tests
      def self.merge_results(out_file, reporter_results)
        if File.exist?(out_file)
          TestMap.reporter.merge(reporter_results, YAML.safe_load_file(out_file))
        else
          reporter_results
        end
      end

      def after_setup
        test_file = resolve_test_file
        if test_file && TestMap.cache.fresh?(test_file)
          @_test_map_skipped = true
          skip 'test-map: cached'
        else
          @recorder = FileRecorder.new.tap(&:trace)
        end

        super
      end

      def before_teardown
        super

        return if @_test_map_skipped || !@recorder

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
