# frozen_string_literal: true

require 'test_helper'

# Tests for trace in use error.
class TraceInUseErrorTest < Minitest::Test
  def test_descriptive_error_message
    assert_includes TestMap::TraceInUseError.default.message,
                    'Trace is already in use.'
  end
end

# Tests for not traced error.
class NotTracedErrorTest < Minitest::Test
  def test_descriptive_error_message
    assert_includes TestMap::NotTracedError.default.message,
                    'Trace has not been started.'
  end
end
