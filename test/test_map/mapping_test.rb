# frozen_string_literal: true

require './test/test_helper'

# Tests for mapping.
class MappingTest < Minitest::Test
  def test_mapping
    expected_result = %w[animal cat dog].map { "test/#{_1}_test.rb" }

    assert_equal expected_result, subject.lookup('animal.rb')
  end

  def test_mapping_applies_natural_mapping
    expected_result = %w[cat horse].map { "test/#{_1}_test.rb" }

    assert_equal expected_result, subject.lookup(*%w[cat.rb horse.rb])
  end

  def subject = @subject ||= TestMap::Mapping.new(fixture_file)
  def fixture_file = "#{Dir.pwd}/test/fixtures/test-map.yml"
end
