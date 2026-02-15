# frozen_string_literal: true

module LlmMemory
  module Processors
    class BronzeProcessor
      def process(raw_entries)
        raw_entries.map do |entry|
          BronzeFact.create!(
            source: entry[:source],
            source_type: entry[:source_type],
            raw_data: entry[:raw_data],
            ingested_at: entry[:ingested_at] || Time.current
          )
        end
      end
    end
  end
end
