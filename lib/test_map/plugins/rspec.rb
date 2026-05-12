# frozen_string_literal: true

require_relative 'rspec/cache_formatter'

TestMap.logger.info 'Loading RSpec plugin'
TestMap.suite_passed = true

module TestMap
  module Plugins
    # RSpec integration for TestMap.
    module RSpec
      def self.write_results
        TestMap.write_results
      end
    end
  end
end

RSpec.configure do |config|
  config.default_formatter = TestMap::Plugins::RSpec::CacheFormatter

  config.before(:context) do
    test_file = self.class.metadata[:file_path].sub("#{Dir.pwd}/", '').sub(%r{^\./}, '')
    skip TestMap::Plugins::RSpec::CacheFormatter::CACHED_MESSAGE if TestMap.cache.fresh?(test_file)
  end

  config.around(:example) do |example|
    if example.metadata[:skip]
      example.run
    else
      recorder = TestMap::FileRecorder.new
      recorder.trace { example.run }
      TestMap.reporter.add recorder.results

      TestMap.suite_passed = false if example.exception && !example.skipped?
    end
  end

  config.after(:suite) { TestMap::Plugins::RSpec.write_results }
end
