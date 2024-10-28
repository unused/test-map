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

    def write(file)
      content = if File.exist?(file) && Config.config[:merge]
                  merge(results, YAML.safe_load_file(file)).to_yaml
                else
                  to_yaml
                end
      File.write file, content
    end

    def results = @results.transform_values { _1.to_a.uniq.sort }.sort.to_h
    def to_yaml = results.to_yaml

    def merge(result, current)
      current.merge(result) do |_key, oldval, newval|
        (oldval + newval).uniq.sort
      end
    end
  end
end
