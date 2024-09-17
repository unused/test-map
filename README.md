
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

## Development

```sh
$ bundle install # install dependencies
$ bundle exec rake # run testsuite
$ bundle exec rubocop # run linter
```

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/unused/test-map).
