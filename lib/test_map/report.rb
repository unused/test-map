# frozen_string_literal: true

require 'yaml'

module TestMap
  # Report keeps track of associated files to test execution.
  class Report
    attr_reader :results

    def initialize = @results = Hash.new(Set.new)

    def add(files)
      test_file, *associated_files = files
      associated_files.each do |file|
        @results[file] = @results[file] << test_file
      end
    end

    def to_yaml = @results.transform_values(&:to_a).to_yaml
  end
end
