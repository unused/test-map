# frozen_string_literal: true

require 'test_helper'

# Test for Animal class
class CatTest < Minitest::Test
  def test_speak
    assert_equal 'Miau', Cat.new.speak
  end

  def test_kind
    assert_equal 'cat', Cat.new.kind
  end
end
