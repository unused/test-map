# frozen_string_literal: true

require_relative 'mapping'
require 'rake/testtask'
require 'minitest'
require 'minitest/unit'

module TestMap
  # TestTask is a rake helper class.
  class TestTask < Rake::TaskLib
    def initialize(name) # rubocop:disable Lint/MissingSuper
      @name = name
    end

    def self.create(name = :test) = new(name).define

    def define
      namespace @name do
        desc 'Run tests for changed files'
        task :changes do
          out_file = "#{Dir.pwd}/.test-map.yml"
          test_files = Mapping.new(out_file).lookup(ARGV[1..]).compact

          # puts "Running tests #{test_files.join(' ')}"
          task = Minitest::TestTask.new
          task.test_globs = test_files
          ruby task.make_test_cmd
        end
      end
    end
  end
end
