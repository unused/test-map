# frozen_string_literal: true

require 'yaml'

module TestMap
  # Report keeps track of associated files to test execution.
  class Report
    def initialize = @results = Hash.new { Set.new }

    def clear
      @results = Hash.new { Set.new }
    end

    def add(files)
      test_file, *associated_files = files
      TestMap.logger.info "Adding #{test_file} with #{associated_files}"
      associated_files.each do |file|
        @results[file] = @results[file] << test_file
      end
    end

    def write(file)
      return if results.empty?

      File.open(file, File::RDWR | File::CREAT) do |f|
        f.flock(File::LOCK_EX)
        data = merge_with_file(f)
        write_to_file(f, data)
        data
      end
    end

    def results = @results.transform_values { _1.to_a.uniq.sort }.sort.to_h
    def to_yaml = results.to_yaml

    def merge(result, current)
      current.merge(result) do |_key, oldval, newval|
        (oldval + newval).uniq.sort
      end
    end

    private

    def merge_with_file(file)
      content = file.read
      return results if content.empty? || !Config.config[:merge]

      merge(results, YAML.safe_load(content) || {})
    end

    def write_to_file(file, data)
      file.rewind
      file.write(data.to_yaml)
      file.flush
      file.truncate(file.pos)
    end
  end
end
