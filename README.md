
# Test-Map

Track associated files of executed tests to optimize test execution on file
changes.

Test-Map results in a file that maps test files to the files they depend on.
You can use this file to run only the tests that are affected by a file change.
This is useful when you have a large test suite and want to optimize the time
spent running tests. Submit a change request and only run tests that depend on
what you changed. Optimizing in such way, the time spent waiting for CI to
verify can be reduced to seconds.

## Usage

Add test-map to your Gemfile.

```sh
$ bundle add test-map
```

### Minitest

Include test-map in your test helper. Typically you want to include it
conditionally so it only generates the test map when needed.

```ruby
# filename: test/test_helper.rb

# Include test-map after minitest has been required
require 'test_map' if ENV['TEST_MAP']
```

Run your tests with the `TEST_MAP` environment variable set.

```sh
$ TEST_MAP=1 bundle exec ruby -Itest test/models/user_test.rb
# or
$ TEST_MAP=1 bundle exec rake test
```

Using the a dedicated rake task you can connect a file watcher and trigger
tests on file changes.

```ruby
# filename: Rakefile
require 'test_map/test_task'

TestMap::TestTask.create
```

Using [entr](https://eradman.com/entrproject/) as example file watcher.

```sh
# find all ruby files | watch them, postpone first execution, clear screen
#   with every run and on file change run test suite for the changed file
#   (placeholder /_).
$ find . -name "*.rb" | entr -cp bundle exec rake test:changes /_
```

### Rspec

Include test-map in your test helper. Typically you want to include it
conditionally so it only generates the test map when needed.

```ruby
# filename: spec/spec_helper.rb
require 'test_map' if ENV['TEST_MAP']
```

Run your tests with the `TEST_MAP` environment variable set.

```sh
$ TEST_MAP=1 bundle exec rspec
```

## Configuration

On demand you can adapt the configuration to your needs.

```ruby
TestMap::Configure.configure do |config|
  config.logger = Logger.new($stdout) # default logs to dev/null
  config.out_file = 'my-test-map.yml' # default is .test-map.yml
  # defaults to [%r{^(vendor)/}] }
  config.exclude_patterns = [%r{^(vendor|other_libraries)/}]
  # register a custom rule to match new files; must implement `call(file)`;
  # defaults to nil
  config.natural_mapping = ->(file) { file.sub(%r{^library/}, 'test/') }
end
```

## Development

Open list of features:

- [ ] Configure file exclude list (e.g. test files are not needed).
- [ ] Auto-handle packs, packs with subdirectories.
- [ ] Demonstrate usage with file watchers.
- [ ] Demonstrate CI pipelines with GitHub actions and GitLab CI.
- [ ] Merge results.

```sh
$ bundle install # install dependencies
$ bundle exec rake # run testsuite
$ bundle exec rubocop # run linter
```

## Contributing

Bug reports and pull requests are very welcome on
[GitHub](https://github.com/unused/test-map).
