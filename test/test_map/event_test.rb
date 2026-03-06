# frozen_string_literal: true

require './test/test_helper'

# Tests for Event pub/sub module.
class EventTest < Minitest::Test
  def setup = TestMap::Event.reset

  def test_publish_without_subscribers_returns_nil
    assert_nil TestMap::Event.publish('cache.found')
  end

  def test_publish_with_block_returns_block_result
    result = TestMap::Event.publish('cache.check') { 42 }

    assert_equal 42, result
  end

  def test_subscribe_receives_published_events
    received = []
    TestMap::Event.subscribe('cache.found') { |topic, **payload| received << [topic, payload] }

    TestMap::Event.publish('cache.found', test_file: 'test/foo_test.rb')

    assert_equal [['cache.found', { test_file: 'test/foo_test.rb' }]], received
  end

  def test_block_form_passes_elapsed_time_to_subscriber
    elapsed_time = nil
    TestMap::Event.subscribe('cache.create') { |_topic, **payload| elapsed_time = payload[:elapsed] }

    TestMap::Event.publish('cache.create') { sleep 0.01 }

    assert_operator elapsed_time, :>=, 0.01
  end

  def test_multiple_subscribers_all_receive_event
    calls = []
    TestMap::Event.subscribe('map.create') { calls << :first }
    TestMap::Event.subscribe('map.create') { calls << :second }

    TestMap::Event.publish('map.create') { nil }

    assert_equal %i[first second], calls
  end

  def test_subscribers_only_receive_matching_topics
    received = []
    TestMap::Event.subscribe('cache.found') { received << :cache }
    TestMap::Event.subscribe('map.create') { received << :map }

    TestMap::Event.publish('cache.found')

    assert_equal [:cache], received
  end

  def test_reset_clears_subscribers
    TestMap::Event.subscribe('cache.found') { raise 'should not be called' }
    TestMap::Event.reset

    TestMap::Event.publish('cache.found')
  end

  def test_no_overhead_without_subscribers
    # Block should still execute and return result
    result = TestMap::Event.publish('trace.record') { 'traced' }

    assert_equal 'traced', result
  end
end
