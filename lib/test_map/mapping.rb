# frozen_string_literal: true

require 'yaml'

module TestMap
  # Mapping looksup test files for changed files.
  Mapping = Data.define(:map_file) do
    def map = YAML.safe_load_file(map_file)

    def lookup(*changed_files)
      new_files = apply_natural_mapping(changed_files - map.keys)
      map.values_at(*changed_files).concat(new_files).flatten.compact.uniq
    end

    def apply_natural_mapping(files)
      files.map { |file| NaturalMapping.new(file).test_files }
    end
  end
end
