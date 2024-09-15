# frozen_string_literal: true

module TestMap
  module Minitest
    # Minitest plugin for TestMap.
    module Plugin
      def self.included(_base)
        ::Minitest.after_run do
          File.write "#{Dir.pwd}/.test-map.yml", TestMap.reporter.to_yaml
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
