# frozen_string_literal: true

# Tests for filter class
class FilterTest < Minitest::Test
  def test_call
    files = %w[dog.rb cat.rb horse.rb]

    assert_equal files, subject.call(files)
  end

  def test_call_with_exclude_patterns
    files = %w[cat.rb dog.rb vendor/gem/horse.rb]

    assert_equal %w[cat.rb dog.rb], subject.call(files)
  end

  def test_set_custom_patterns
    filter = subject.new
    files = %w[cat.rb dog.rb horse.rb]
    filter.exclude_patterns = [/dog/, /cat/]

    assert_equal %w[horse.rb], filter.call(files)
  end

  private

  def subject = @subject ||= TestMap::Filter
end
