# frozen_string_literal: true

module LlmMemory
  module Collectors
    class RailsLogCollector < BaseCollector
      SOURCE_TYPE = "rails_log"

      def initialize(log_path: nil)
        super()
        @log_path = log_path || LlmMemory.configuration.rails_log_path
      end

      def collect
        return [] unless @log_path && File.exist?(@log_path)

        entries = []
        File.foreach(@log_path) do |line|
          parsed = parse_log_line(line)
          next unless parsed

          entries << build_raw_entry(
            source: @log_path,
            source_type: SOURCE_TYPE,
            raw_data: parsed
          )
        end
        entries
      end

      private

      def parse_log_line(line)
        line = line.strip
        return nil if line.empty?

        { message: line, timestamp: Time.current.iso8601 }
      end
    end
  end
end
