# frozen_string_literal: true

require 'yaml'

module TestMap
  # Natural mapping determines the test file for a given source file by
  # applying common and configurable rules and transformation.
  class NaturalMapping
    CommonRule = Struct.new(:file) do
      def self.call(file) = new(file).call

      def call
        if File.exist?('test')
          transform('test')
        elsif File.exist?('spec')
          transform('spec')
        end
      end

      def transform(type)
        test_file = "#{File.basename(file, '.rb')}_#{type}.rb"
        test_path = File.dirname(file).sub('app/', '')
        test_path = nil if test_path == '.'
        [type, test_path, test_file].compact.join('/')
      end
    end

    attr_reader :file

    def initialize(file) = @file = file
    def test_files = Array(transform(file))

    def transform(file)
      self.class.registered_rules.each do |rule|
        test_files = rule.call(file)

        return test_files if test_files
      end

      nil
    end

    def self.registered_rules
      @registered_rules ||= [
        Config.config[:natural_mapping],
        CommonRule
      ].compact
    end
  end
end
