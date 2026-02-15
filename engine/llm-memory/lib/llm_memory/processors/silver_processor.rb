# frozen_string_literal: true

module LlmMemory
  module Processors
    class SilverProcessor
      def process(bronze_facts)
        bronze_facts.group_by(&:source_type).flat_map do |source_type, facts|
          correlate_and_normalize(source_type, facts)
        end
      end

      private

      def correlate_and_normalize(source_type, facts)
        correlation_id = SecureRandom.uuid
        normalized = facts.map { |f| normalize(f) }

        [SilverFact.create!(
          bronze_fact_ids: facts.map(&:id),
          normalized_data: normalized,
          correlation_id: correlation_id,
          entity_type: source_type,
          processed_at: Time.current
        )]
      end

      def normalize(bronze_fact)
        bronze_fact.raw_data
      end
    end
  end
end
