
# Test-Map

Track associated files of executed tests to optimize test execution on file
changes.

## Usage

Add test-map to your Gemfile.

```sh
$ bundle add test-map
```

### Minitest

Include minitest plugin.

```ruby
# filename: test/test_helper.rb

require 'test_map'
require 'test_map/minitest/plugin'

# For Rails projects...
class ActiveSupport::TestCase
  include TestMap::Minitest::Plugin

  # ...
end

# Or custom projects using Minitest...
class Minitest::Test
  include TestMap::Minitest::Plugin
end
```

## Development

```sh
$ bundle install # install dependencies
$ bundle exec rake # run testsuite
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/unused/test-map.
