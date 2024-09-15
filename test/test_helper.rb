# frozen_string_literal: true

require 'minitest/autorun'

require 'test_map'
require 'test_map/minitest/plugin'

class Minitest::Test
  include TestMap::Minitest::Plugin
end
