# frozen_string_literal: true

require 'digest'
require 'yaml'

module TestMap
  # Cache tracks file checksums to skip unchanged tests.
  class Cache
    GLOBAL_FILES = %w[Gemfile.lock .ruby-version].freeze

    def initialize(cache_file, map_file, root: Dir.pwd)
      @cache_file = cache_file
      @map_file = map_file
      @root = root
      @global_files_changed = nil
      @current_checksums = {}
      @file_exists_cache = {}
    end

    def fresh?(test_file)
      return false unless cached_checksums
      return false if global_files_changed?

      files_to_check = [test_file].concat(source_files_for(test_file))
      files_to_check.all? { |f| file_exist?(f) && current_checksum(f) == cached_checksums[f] }
    end

    def write(results)
      all_files = collect_tracked_files(results)
      checksums = all_files.each_with_object({}) do |file, hash|
        hash[file] = current_checksum(file) if file_exist?(file)
      end
      File.write(@cache_file, checksums.sort.to_h.to_yaml)
    end

    private

    def cached_checksums
      @cached_checksums ||= File.exist?(@cache_file) && YAML.safe_load_file(@cache_file)
    end

    def global_files_changed?
      return @global_files_changed unless @global_files_changed.nil?

      @global_files_changed = GLOBAL_FILES.any? do |f|
        file_exist?(f) && current_checksum(f) != cached_checksums[f]
      end
    end

    def inverted_map = @inverted_map ||= build_inverted_map

    def build_inverted_map
      return {} unless File.exist?(@map_file)

      map = YAML.safe_load_file(@map_file)
      inverted = Hash.new { |h, k| h[k] = [] }
      map.each do |source, tests|
        tests.each { |t| inverted[t] << source }
      end
      inverted
    end

    def source_files_for(test_file)
      inverted_map[test_file] || []
    end

    def current_checksum(file)
      @current_checksums[file] ||= Digest::SHA256.file(File.join(@root, file)).hexdigest
    end

    def file_exist?(file)
      return @file_exists_cache[file] if @file_exists_cache.key?(file)

      @file_exists_cache[file] = File.exist?(File.join(@root, file))
    end

    def collect_tracked_files(results)
      sources = results.keys
      tests = results.values.flatten.uniq
      all = (sources + tests + GLOBAL_FILES).uniq
      all.select { |f| file_exist?(f) }
    end
  end
end
