# frozen_string_literal: true

require './test/test_helper'

# Tests for CachedSkip exception.
class CachedSkipTest < Minitest::Test
  def test_inherits_from_minitest_skip
    assert_operator TestMap::CachedSkip, :<, Minitest::Skip
  end

  def test_default_message
    error = TestMap::CachedSkip.new

    assert_equal 'test-map: cached', error.message
  end

  def test_result_label
    error = TestMap::CachedSkip.new

    assert_equal 'Cached', error.result_label
  end

  def test_result_code
    error = TestMap::CachedSkip.new

    assert_equal 'C', error.result_code
  end
end

# Tests for CacheReporter.
class CacheReporterTest < Minitest::Test
  def setup
    @io = StringIO.new
    @composite = Minitest::CompositeReporter.new
    @summary = Minitest::SummaryReporter.new(@io, {})
    @composite.reporters << @summary
    @reporter = TestMap::Plugins::Minitest::CacheReporter.new(@io, {}, composite: @composite)
    @composite.reporters.unshift(@reporter)

    @composite.start
  end

  def test_record_counts_cached_results
    @composite.record(cached_result)
    @composite.record(passing_result)

    assert_equal 1, @reporter.cached
  end

  def test_report_adjusts_skip_count
    @composite.record(cached_result)
    @composite.report

    assert_equal 0, @summary.skips
  end

  def test_report_removes_cached_from_summary_results
    @composite.record(cached_result)
    @composite.report

    cached_in_results = @summary.results.any? { |r| r.failure.is_a?(TestMap::CachedSkip) }

    refute cached_in_results
  end

  def test_summary_includes_cached_count
    @composite.record(cached_result)
    @composite.record(passing_result)
    @composite.report

    assert_includes @summary.summary, '1 cached'
  end

  def test_summary_shows_zero_cached_when_none
    @composite.record(passing_result)
    @composite.report

    assert_includes @summary.summary, '0 cached'
  end

  private

  def cached_result
    result = Minitest::Result.new('test_cached')
    result.failures = [TestMap::CachedSkip.new]

    result.assertions = 0
    result.time = 0.001
    result
  end

  def passing_result
    result = Minitest::Result.new('test_passing')
    result.failures = []

    result.assertions = 1
    result.time = 0.001
    result
  end
end

# Tests for before_setup cache skip behavior.
class MinitestPluginSetupSkipTest < Minitest::Test
  def test_setup_not_called_when_cached
    setup_called = false

    klass = build_test_class(setup_called: -> { setup_called = true })

    with_stubbed_cache('test/fake_test.rb') do
      result = klass.new(:test_dummy).run

      assert_predicate result, :skipped?
      assert_instance_of TestMap::CachedSkip, result.failure
      refute setup_called, 'setup should not have been called'
    end
  end

  private

  def build_test_class(setup_called:)
    Class.new(Minitest::Test) do
      include TestMap::Plugins::Minitest

      define_method(:resolve_test_file) { 'test/fake_test.rb' }
      define_method(:setup) { setup_called.call }

      define_method(:test_dummy) {} # rubocop:disable Lint/EmptyBlock
    end
  end

  def with_stubbed_cache(test_file)
    cache = Minitest::Mock.new
    cache.expect(:fresh?, true, [test_file])

    original_cache = TestMap.instance_variable_get(:@cache)
    TestMap.instance_variable_set(:@cache, cache)

    yield
  ensure
    TestMap.instance_variable_set(:@cache, original_cache)
  end
end
