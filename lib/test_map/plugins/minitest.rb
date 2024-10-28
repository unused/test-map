# frozen_string_literal: true

module TestMap
  module Plugins
    # Minitest plugin for TestMap.
    module Minitest
      def self.included(_base)
        TestMap.logger.info 'Registering hooks for Minitest'
        ::Minitest.after_run do
          TestMap.reporter.write "#{Dir.pwd}/#{Config.config[:out_file]}"
        end
      end

      def after_setup
        @recorder = FileRecorder.new.tap(&:trace)

        super
      end

      def before_teardown
        super

        @recorder.stop
        TestMap.reporter.add @recorder.results
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
