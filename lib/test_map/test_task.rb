# frozen_string_literal: true

require_relative 'mapping'

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
          test_files = Mapping.new(out_file).lookup(ARGV[1..])
          # TODO: works with Rails, not in general
          Rake::Task[@name].invoke test_files
        end
      end
    end
  end
end
