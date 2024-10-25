# frozen_string_literal: true

TestMap.logger.info 'Loading RSpec plugin'

RSpec.configure do |config|
  config.around(:example) do |example|
    # path = example.metadata[:example_group][:file_path]
    recorder = TestMap::FileRecorder.new
    recorder.trace { example.run }
    TestMap.reporter.add recorder.results
  end

  config.after(:suite) do
    result = TestMap.reporter.to_yaml
    File.write "#{Dir.pwd}/#{TestMap::Config.config[:out_file]}", result
  end
end
