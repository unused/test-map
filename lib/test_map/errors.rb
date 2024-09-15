# frozen_string_literal: true

module TestMap
  # TraceInUseError is raised when a trace is already in use.
  class TraceInUseError < StandardError
    def self.default
      new <<~MSG
        Trace is already in use. Find for a second send of `#trace` and ensure
        you only use one. Use `#results` to get the results.
      MSG
    end
  end

  # NotTracedError is raised when a trace has not been started.
  class NotTracedError < StandardError
    def self.default
      new <<~MSG
        Trace has not been started. Use `#trace` to start tracing.
      MSG
    end
  end
end
