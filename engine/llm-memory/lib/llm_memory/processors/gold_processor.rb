# frozen_string_literal: true

module LlmMemory
  module Processors
    class GoldProcessor
      def process(silver_facts)
        silver_facts.map do |silver_fact|
          refine(silver_fact)
        end
      end

      private

      def refine(silver_fact)
        GoldInsight.create!(
          silver_fact_ids: [silver_fact.id],
          insight_type: derive_insight_type(silver_fact),
          summary: summarize(silver_fact),
          score: calculate_score(silver_fact),
          metadata: build_metadata(silver_fact),
          lifecycle_published: false,
          refined_at: Time.current
        )
      end

      def derive_insight_type(silver_fact)
        silver_fact.entity_type
      end

      def summarize(silver_fact)
        data = silver_fact.normalized_data
        "#{silver_fact.entity_type}: #{Array(data).size} correlated facts"
      end

      def calculate_score(silver_fact)
        Array(silver_fact.normalized_data).size.clamp(0.0, 1.0).to_f
      end

      def build_metadata(silver_fact)
        { correlation_id: silver_fact.correlation_id, entity_type: silver_fact.entity_type }
      end
    end
  end
end
