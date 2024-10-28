# frozen_string_literal: true

require 'test_helper'

# Tests for trace in use error.
class ReportTest < Minitest::Test
  def test_empty_results
    assert_empty described_class.new.results
  end

  def test_merges_two_hashes
    report = described_class.new
    result = report.merge({ a: [1, 2, 3], b: [4, 5, 6] },
                          { a: [3, 4, 5], c: [6, 7, 8] })
    expected_result = { a: [1, 2, 3, 4, 5], b: [4, 5, 6], c: [6, 7, 8] }

    assert_equal expected_result, result
  end

  private

  def described_class = TestMap::Report
end
