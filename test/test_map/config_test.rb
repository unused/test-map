# frozen_string_literal: true

require 'test_helper'

# Tests for configuration.
class ConfigTest < Minitest::Test
  def test_respond_to_confgiure
    assert_respond_to subject, :configure
  end

  def test_default_configuration
    assert_equal '.test-map.yml', subject.config[:out_file]
    assert_kind_of Logger, subject.config[:logger]
  end

  def test_ensure_default_keys
    expected_keys = %i[logger out_file exclude_patterns natural_mapping
                       skip_files merge]

    assert_equal expected_keys, subject.config.keys
  end

  private

  def subject = TestMap::Config
end
