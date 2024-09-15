# frozen_string_literal: true

require 'test_helper'

# Tests for trace in use error.
class ReportTest < Minitest::Test
  def test_empty_results
    assert_empty described_class.new.results
  end

  private

  def described_class = TestMap::Report
end
