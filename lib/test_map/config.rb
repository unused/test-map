# frozen_string_literal: true

require 'logger'

module TestMap
  # Configuration for TestMap
  class Config
    def self.config = @config ||= default_config
    def self.configure = yield(config)

    def self.default_config
      { logger: Logger.new('/dev/null') }
    end
  end
end
