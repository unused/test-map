# frozen_string_literal: true

TestMap.logger.info 'Loading RSpec plugin'
TestMap.suite_passed = true

RSpec.configure do |config|
  config.around(:example) do |example|
    test_file = example.metadata[:file_path].sub("#{Dir.pwd}/", '').sub(%r{^\./}, '')

    if TestMap.cache.fresh?(test_file)
      skip 'test-map: cached'
    else
      recorder = TestMap::FileRecorder.new
      recorder.trace { example.run }
      TestMap.reporter.add recorder.results

      TestMap.suite_passed = false if example.exception && !example.skipped?
    end
  end

  config.after(:suite) do
    out_file = "#{Dir.pwd}/#{TestMap::Config.config[:out_file]}"
    reporter_results = TestMap.reporter.results

    # All tests were cache-skipped, existing files are still valid
    next if reporter_results.empty?

    # Merge with existing map to preserve mappings for cache-skipped tests
    full_results = if File.exist?(out_file)
                     TestMap.reporter.merge(reporter_results, YAML.safe_load_file(out_file))
                   else
                     reporter_results
                   end

    File.write(out_file, full_results.to_yaml)
    TestMap.cache.write(full_results) if TestMap.suite_passed
  end
end
