# frozen_string_literal: true

require './test/test_helper'

# Tests for mapping.
class NaturalMappingTest < Minitest::Test
  def test_mapping
    mapping = subject.new('lib/animal.rb')

    assert_equal ['test/lib/animal_test.rb'], mapping.test_files
  end

  def test_rails_mapping
    mapping = subject.new('app/model/animal.rb')

    assert_equal ['test/model/animal_test.rb'], mapping.test_files
  end

  def test_registered_rules
    refute_empty subject.registered_rules
  end

  def test_specs
    File.stub(:exist?, ->(type) { type == 'spec' }) do
      mapping = subject.new('app/model/animal.rb')

      assert_equal ['spec/model/animal_spec.rb'], mapping.test_files
    end
  end

  def test_no_known_test_lib
    File.stub(:exist?, ->(_) { false }) do
      mapping = subject.new('lib/animal.rb')
      puts mapping.test_files

      assert_empty mapping.test_files
    end
  end

  def test_has_registered_default_rules
    assert_predicate subject.registered_rules, :any?
  end

  private

  def subject = TestMap::NaturalMapping
end
