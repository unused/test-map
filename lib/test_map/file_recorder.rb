# frozen_string_literal: true

module TestMap
  # FileRecorder records files accessed during test execution.
  class FileRecorder
    def initialize = @files = []

    def trace(&block)
      raise TraceInUseError.default if @trace&.enabled?

      @trace = TracePoint.new(:call) do |tp|
        TestMap.logger.debug "#{tp.path}:#{tp.lineno}"
        @files << tp.path
      end

      if block_given?
        @trace.enable { block.call }
      else
        @trace.enable
      end
    end

    def stop = @trace&.disable

    # TODO: also add custom filters, e.g. for vendor directories
    def results
      raise NotTracedError.default unless @trace

      cwd = "#{Dir.pwd}/"
      @files.filter { _1.start_with? cwd }
            .map { _1.sub(cwd, '') }
            .then { Filter.call _1 }
    end
  end
end
