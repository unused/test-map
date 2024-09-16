# frozen_string_literal: true

require 'test_helper'

# Test for Animal class
class DogTest < Minitest::Test
  def test_speak
    assert_equal 'Wuff', Dog.new.speak
  end

  def test_kind
    assert_equal 'dog', Dog.new.kind
  end
end
