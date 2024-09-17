# frozen_string_literal: true

module TestMap
  # TestTask is a rake helper class.
  class TestTask < Rake::TaskLib
    def initialize(name)
      super
      @name = name
    end

    def self.create(name = :test) = new(name).define

    def define
      desc 'Run tests for changed files'
      task "#{@name}:changes" do |_, changed_files|
        test_files = Mapping.new(config.out_file).lookup changed_files
        Rake::Task[@name].invoke test_files
      end
    end
  end
end
