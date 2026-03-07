# frozen_string_literal: true

require 'rspec/core/formatters/progress_formatter'

module TestMap
  module Plugins
    module RSpec
      # Formatter that shows `C` for cached tests instead of `*` (pending).
      # Extends ProgressFormatter so it can serve as the default formatter.
      # Adjusts the summary to show cached count and filters cached tests
      # from the pending output.
      class CacheFormatter < ::RSpec::Core::Formatters::ProgressFormatter
        CACHED_MESSAGE = 'test-map: cached'

        ::RSpec::Core::Formatters.register self,
                                           :example_passed, :example_pending, :example_failed,
                                           :start_dump, :dump_summary, :dump_pending

        def initialize(output)
          super
          @cached_count = 0
        end

        def example_pending(notification)
          if cached?(notification.example)
            @cached_count += 1
            output.print ::RSpec::Core::Formatters::ConsoleCodes.wrap('c', :cyan)
          else
            super
          end
        end

        def dump_pending(notification)
          examples = notification.pending_examples
          cached = examples.select { |ex| cached?(ex) }
          return if examples.size == cached.size

          cached.each { |ex| examples.delete(ex) }
          super
          cached.each { |ex| examples.push(ex) }
        end

        def dump_summary(summary)
          if @cached_count.positive?
            cached_count = @cached_count
            original_totals_line = summary.method(:totals_line)
            summary.define_singleton_method(:totals_line) do
              "#{original_totals_line.call}, #{cached_count} cached"
            end
          end
          super
        end

        private

        def cached?(example)
          example.execution_result.pending_message == CACHED_MESSAGE
        end
      end
    end
  end
end
