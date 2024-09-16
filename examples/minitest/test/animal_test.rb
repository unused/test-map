# frozen_string_literal: true

require 'test_helper'

# Test for Animal class
class AnimalTest < Minitest::Test
  def test_speak
    assert_raises(NotImplementedError) { Animal.new.speak }
  end

  def test_kind
    assert_equal 'animal', Animal.new.kind
  end
end
