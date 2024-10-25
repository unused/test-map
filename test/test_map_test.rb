# frozen_string_literal: true

require 'test_helper'

class TestMapTest < Minitest::Test
  def test_presence_of_version_number
    refute_nil TestMap::VERSION
  end
end
