# frozen_string_literal: true

require 'yaml'
require 'tempfile'

module TestMap
  # Report keeps track of associated files to test execution.
  class Report
    def initialize
      @results = Hash.new { |hash, key| hash[key] = Set.new }
    end

    def clear
      @results = Hash.new { |hash, key| hash[key] = Set.new }
    end

    def add(files)
      test_file, *associated_files = files
      TestMap.logger.info "Adding #{test_file} with #{associated_files}"
      associated_files.each do |file|
        @results[file] << test_file
      end
    end

    def write(file_path)
      return if results.empty?

      lock_path = "#{file_path}.lock"
      File.open(lock_path, File::RDWR | File::CREAT) do |lock_file|
        lock_file.flock(File::LOCK_EX)

        current_data = read_file file_path
        data = merge(results, current_data)
        atomic_write(file_path, data.to_yaml)

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

    def atomic_write(file_path, content)
      temp_file = Tempfile.new([File.basename(file_path), '.tmp'], File.dirname(file_path))
      begin
        temp_file.write(content)
        temp_file.close
        File.rename(temp_file.path, file_path)
      ensure
        temp_file.close!
      end
    end

    def read_file(file_path)
      return {} unless File.exist?(file_path) && Config.config[:merge]

      YAML.safe_load_file(file_path) || {}
    end
  end
end
