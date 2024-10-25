# frozen_string_literal: true

require_relative 'mapping'
require 'rake/testtask'
require 'minitest'
require 'minitest/unit'

module TestMap
  # TestTask is a rake helper class.
  class TestTask < Rake::TaskLib
    # Error for unknown test task adapter.
    class UnknownAdapterError < StandardError; end

    def initialize(name) # rubocop:disable Lint/MissingSuper
      @name = name
    end

    # Adapter for rspec test task
    class RailsTestTask
      attr_accessor :files

      def call = Rails::TestUnit::Runner.run_from_rake('test', files)
    end

    # Adapter for minitest test task.
    class MinitestTask < Minitest::TestTask
      def call = ruby(make_test_cmd, verbose: false)

      def files=(test_files)
        self.test_globs = test_files
      end
    end

    # Adapter for rspec test task
    class RSpecTask
      attr_accessor :files

      def call = `rspec #{files.join(' ')}`
    end

    def self.create(name = :test) = new(name).define

    def define
      namespace @name do
        desc 'Run tests for changed files'
        task :changes do
          out_file = "#{Dir.pwd}/.test-map.yml"
          args = defined?(Rails) ? ENV['TEST']&.split : ARGV[1..]
          test_files = Mapping.new(out_file).lookup(*args)

          # puts "Running tests #{test_files.join(' ')}"
          test_task.files = test_files
          test_task.call
        end
      end
    end

    def test_task = @test_task ||= build_test_task

    def build_test_task
      if defined?(Rails)
        return RailsTestTask.new
      elsif defined?(Minitest)
        require 'minitest/test_task'
        return MinitestTask.new
      elsif defined?(RSpec)
        return RSpecTask.new
      end

      raise UnknownAdapterError, 'No test task adapter found'
    end
  end
end
