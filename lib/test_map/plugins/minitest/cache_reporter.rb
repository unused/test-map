# frozen_string_literal: true

module TestMap
  module Plugins
    module Minitest
      # Reporter that tracks cached test count and appends it to the summary.
      class CacheReporter < ::Minitest::StatisticsReporter
        attr_accessor :cached, :composite

        def initialize(io = $stdout, options = {}, composite: nil)
          super(io, options)
          self.cached = 0
          self.composite = composite
        end

        def record(result)
          super
          self.cached += 1 if result.failure.is_a?(TestMap::CachedSkip)
        end

        def report
          super
          return unless composite

          summary_reporter = composite.reporters.find { |r| r.is_a?(::Minitest::SummaryReporter) }
          return unless summary_reporter

          summary_reporter.results.reject! { |r| r.failure.is_a?(TestMap::CachedSkip) }
          summary_reporter.skips -= cached if summary_reporter.skips
          patch_summary(summary_reporter)
        end

        private

        def patch_summary(summary_reporter)
          cached_count = cached
          original_summary = summary_reporter.method(:summary)

          summary_reporter.define_singleton_method(:summary) do
            "#{original_summary.call}, #{cached_count} cached"
          end
        end
      end
    end
  end
end

module Minitest # :nodoc:
  def self.plugin_test_map_cache_init(options)
    cache_reporter = TestMap::Plugins::Minitest::CacheReporter.new(options[:io], options, composite: reporter)
    reporter.reporters.unshift(cache_reporter)
  end
end
