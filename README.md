
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

Require test-map in your test helper or spec helper.

```ruby
# filename: test/test_helper.rb
require 'test_map'
```

## Example Run

Running the testsuite, test-map creates a mapping of tests to their code files,
as well as a test-file result cache. Running the testsuite again, all
successfully run tests are cached and skipped. Chaning a file, **only tests
that need to be run are executed**.

```sh
# Running the testsuite for the first time, all tests are executed and mapped
 > be rake
Run options: --seed 10112

# Running:

.......................................................

Finished in 0.042190s, 1303.6402 runs/s, 1730.2861 assertions/s.
55 runs, 73 assertions, 0 failures, 0 errors, 0 skips, 0 cached

# Running again without changes, all tests are cached and skipped
 > be rake
Run options: --seed 40581

# Running:

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

Finished in 0.007902s, 6960.1126 runs/s, 0.0000 assertions/s.
55 runs, 0 assertions, 0 failures, 0 errors, 0 skips, 55 cached

# Change a file and rerun the testsuite
 > be rake
Run options: --seed 47682

# Running:

CCCCCCCCCC...CCCCCCCCCCCC.....CCCCCCCCCCCCCCCCCCCCCCCCC

Finished in 0.014029s, 3920.3764 runs/s, 570.2366 assertions/s.
55 runs, 8 assertions, 0 failures, 0 errors, 0 skips, 47 cached
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
