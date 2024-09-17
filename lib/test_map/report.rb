# frozen_string_literal: true

require 'yaml'

module TestMap
  # Report keeps track of associated files to test execution.
  class Report
    def initialize = @results = Hash.new { Set.new }

    def add(files)
      test_file, *associated_files = files
      TestMap.logger.info "Adding #{test_file} with #{associated_files}"
      associated_files.each do |file|
        @results[file] = @results[file] << test_file
      end
    end

    def results = @results.transform_values { _1.to_a.sort }.sort.to_h
    def to_yaml = results.to_yaml
  end
end
