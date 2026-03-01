
# Test-Map

Track associated files of executed tests to optimize test execution on file
changes.

Test-Map records which source files each test touches and caches their
checksums. On subsequent runs, tests whose dependencies haven't changed are
automatically skipped. This is useful when you have a large test suite and want
to optimize the time spent running tests locally or in CI.

## Usage

Add test-map to your Gemfile.

```sh
$ bundle add test-map
```

### Minitest

Include test-map in your test helper.

```ruby
# filename: test/test_helper.rb

# Include test-map after minitest has been required
require 'test_map'
```

Run your tests. On the first run test-map records file dependencies into
`.test-map.yml` and checksums into `.test-cache.yml`. On subsequent runs,
tests whose source files haven't changed are automatically skipped.

```sh
$ bundle exec ruby -Itest test/models/user_test.rb
# or
$ bundle exec rake test
```

### Rspec

Include test-map in your spec helper.

```ruby
# filename: spec/spec_helper.rb
require 'test_map'
```

Run your tests. Caching works the same as with Minitest.

```sh
$ bundle exec rspec
```

## Configuration

On demand you can adapt the configuration to your needs.

```ruby
TestMap::Config.configure do |config|
  config[:logger] = Logger.new($stdout) # default logs to dev/null
  config[:merge] = false # merge results (e.g. with multiple testsuites)
  config[:out_file] = 'my-test-map.yml' # default is .test-map.yml
  config[:cache_file] = 'my-test-cache.yml' # default is .test-cache.yml
  # defaults to [%r{^(vendor)/}] }
  config[:exclude_patterns] = [%r{^(vendor|other_libraries)/}]
  # register a custom rule to match new files; must implement `call(file)`;
  # defaults to nil
  config[:natural_mapping] = ->(file) { file.sub(%r{^library/}, 'test/') }
end
```

## Development

```sh
$ bundle install # install dependencies
$ bundle exec rake # run testsuite
$ bundle exec rubocop # run linter
```

## Contributing

Bug reports and pull requests are very welcome on
[GitHub](https://github.com/unused/test-map).
