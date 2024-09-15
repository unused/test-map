# frozen_string_literal: true

require 'minitest/autorun'

require 'test_map'
require 'test_map/minitest/plugin'

module Minitest
  # Include test-map plugin with minitest testcases.
  class Test
    include TestMap::Minitest::Plugin
  end
end
