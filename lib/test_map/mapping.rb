# frozen_string_literal: true

require 'yaml'

module TestMap
  # Mapping looksup test files for changed files.
  Mapping = Data.define(:map_file) do
    def map = YAML.safe_load_file(map_file)
    def lookup(changed_files) = map.values_at(*changed_files).flatten.uniq
  end
end
