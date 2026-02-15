# frozen_string_literal: true

module LlmMemory
  module Api
    module V1
      class PipelineController < ActionController::API
        def collect
          collectors = [
            Collectors::LlmStateCollector.new,
            Collectors::RailsLogCollector.new,
            Collectors::OpenTelemetryCollector.new
          ]
          raw_entries = collectors.flat_map(&:collect)
          bronze_facts = Processors::BronzeProcessor.new.process(raw_entries)

          render json: { collected: raw_entries.size, bronze_facts_created: bronze_facts.size }
        end

        def process_silver
          bronze_facts = BronzeFact.unprocessed
          silver_facts = Processors::SilverProcessor.new.process(bronze_facts)

          render json: { bronze_processed: bronze_facts.size, silver_facts_created: silver_facts.size }
        end

        def process_gold
          silver_facts = SilverFact.unprocessed
          gold_insights = Processors::GoldProcessor.new.process(silver_facts)

          render json: { silver_processed: silver_facts.size, gold_insights_created: gold_insights.size }
        end

        def run_all
          raw = [
            Collectors::LlmStateCollector.new,
            Collectors::RailsLogCollector.new,
            Collectors::OpenTelemetryCollector.new
          ].flat_map(&:collect)

          bronze = Processors::BronzeProcessor.new.process(raw)
          silver = Processors::SilverProcessor.new.process(bronze)
          gold = Processors::GoldProcessor.new.process(silver)

          render json: {
            collected: raw.size,
            bronze: bronze.size,
            silver: silver.size,
            gold: gold.size
          }
        end
      end
    end
  end
end
