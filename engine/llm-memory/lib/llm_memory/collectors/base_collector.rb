# frozen_string_literal: true

module LlmMemory
  module Collectors
    class BaseCollector
      def collect
        raise NotImplementedError, "#{self.class}#collect must be implemented"
      end

      private

      def build_raw_entry(source:, source_type:, raw_data:)
        {
          source: source,
          source_type: source_type,
          raw_data: raw_data,
          ingested_at: Time.current
        }
      end
    end
  end
end
