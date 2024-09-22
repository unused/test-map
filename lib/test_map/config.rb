# frozen_string_literal: true

require 'logger'

module TestMap
  # Configuration for TestMap
  class Config
    def self.[](key) = config[key]
    def self.config = @config ||= default_config
    def self.configure = yield(config)

    def self.default_config
      { logger: Logger.new('/dev/null'), out_file: '.test-map.yml',
        exclude_patterns: [%r{^(vendor)/}], natural_mapping: nil }
    end
  end
end
