# frozen_string_literal: true

module LlmMemory
  module Collectors
    class OpenTelemetryCollector < BaseCollector
      SOURCE_TYPE = "open_telemetry"

      def initialize(endpoint: nil)
        super()
        @endpoint = endpoint || LlmMemory.configuration.otel_endpoint
      end

      def collect
        # Stubbed: will read from OpenTelemetry event streams
        # Returns array of raw entries for bronze processing
        []
      end
    end
  end
end
