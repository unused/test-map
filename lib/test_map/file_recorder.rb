# frozen_string_literal: true

module TestMap
  # FileRecorder records files accessed during test execution.
  class FileRecorder
    def initialize = @files = []

    def trace
      raise TraceInUseError.default if @trace&.enabled?

      @trace = TracePoint.new(:call) do
        @files << _1.path
      end.tap(&:enable)
    end

    def stop = @trace&.disable

    # TODO: also add custom filters, e.g. for vendor directories
    def results
      raise NotTracedError.default unless @trace

      @files.filter { _1.start_with? Dir.pwd }
            .map { _1.sub("#{Dir.pwd}/", '') }
    end
  end
end
