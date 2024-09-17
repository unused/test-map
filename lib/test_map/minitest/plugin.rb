# frozen_string_literal: true

module TestMap
  module Minitest
    # Minitest plugin for TestMap.
    module Plugin
      def self.included(_base)
        TestMap.logger.info 'Registering hooks for Minitest'
        ::Minitest.after_run do
          result = TestMap.reporter.to_yaml
          File.write "#{Dir.pwd}/#{Config.config[:out_file]}", result
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

if defined?(Rails)
  ActiveSupport::TestCase.include TestMap::Rails::Plugin
else
  Minitest::Test.include TestMap::Minitest::Plugin
end
