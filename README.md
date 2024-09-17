
# Test-Map

Track associated files of executed tests to optimize test execution on file
changes.

## Usage

Add test-map to your Gemfile.

```sh
$ bundle add test-map
```

### Minitest

Include minitest plugin in your test helper. Typically you want to include it
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

WIP

## Development

```sh
$ bundle install # install dependencies
$ bundle exec rake # run testsuite
$ bundle exec rubocop # run linter
```

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/unused/test-map).
