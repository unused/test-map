# frozen_string_literal: true

require 'yaml'

module TestMap
  # Mapping looksup test files for changed files.
  Mapping = Data.define(:map_file) do
    def map = YAML.safe_load_file(map_file)

    def lookup(*changed_files)
      new_files = apply_natural_mapping(changed_files - map.keys)
      map.values_at(*changed_files).flatten.compact.uniq.concat(new_files)
    end

    def apply_natural_mapping(files)
      pattern = if File.exist?("#{Dir.pwd}/test")
                  'test/%s_test.rb'
                elsif File.exist?("#{Dir.pwd}/spec")
                  'spec/%s_spec.rb'
                  # Handle files in packs
                end
      files.map { format(pattern, File.basename(_1, '.rb')) }
    end
  end
end
