# frozen_string_literal: true

module TestMap
  # Publish/subscribe event bus. No overhead when no subscribers.
  #
  # Topics use `type.action` format, e.g. `cache.create`, `map.create`.
  #
  # Block form measures elapsed time and passes it to subscribers:
  #   Event.publish('cache.create') { write_cache }
  #
  # Fire-and-forget form for simple notifications:
  #   Event.publish('cache.found', test_file:)
  module Event
    @subscribers = {}

    class << self
      def subscribe(topic, &block)
        (@subscribers[topic] ||= []) << block
      end

      def publish(topic, **payload, &block)
        listeners = @subscribers[topic]
        return notify(listeners, topic, **payload) unless block
        return yield unless listeners

        publish_with_timing(listeners, topic, **payload, &block)
      end

      def reset
        @subscribers = {}
      end

      private

      def notify(listeners, topic, **payload)
        listeners&.each { |cb| cb.call(topic, **payload) }
      end

      def publish_with_timing(listeners, topic, **payload)
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        result = yield
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        listeners.each { |cb| cb.call(topic, elapsed:, **payload) }
        result
      end
    end
  end
end
