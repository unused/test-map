# frozen_string_literal: true

require 'test_helper'
require 'fixtures/sample'

# Tests for file recorder.
class FileRecorderTest < Minitest::Test
  def test_detects_double_trace
    assert_raises TestMap::TraceInUseError do
      2.times { subject.trace }
    end
  end

  def test_warn_on_no_trace
    assert_raises TestMap::NotTracedError do
      subject.results
    end
  end

  def test_tracing
    subject.trace
    subject.stop

    assert_equal 'file_recorder.rb', File.basename(subject.results.last)
  end

  def test_tracing_sample
    subject.trace { Sample.new.hello }

    assert_equal 'sample.rb', File.basename(subject.results.first)
  end

  def test_tracing_in_block_mode
    subject.trace { Sample.new.hello }

    refute_predicate subject.instance_variable_get(:@trace), :enabled?
  end

  private

  def subject = @subject ||= TestMap::FileRecorder.new
end
