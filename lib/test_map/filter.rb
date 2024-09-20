# frozen_string_literal: true

module TestMap
  # Filter skips files that are not part of the project.
  class Filter
    attr_writer :exclude_patterns

    def self.call(files) = new.call(files)
    def call(files) = files.reject { exclude? _1 }
    def exclude_patterns = @exclude_patterns ||= Config[:exclude_patterns]
    def exclude?(file) = exclude_patterns.any? { file.match? _1 }
  end
end
