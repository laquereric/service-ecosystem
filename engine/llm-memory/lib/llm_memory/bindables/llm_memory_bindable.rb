# frozen_string_literal: true

module LlmMemory
  module Bindables
    class LlmMemoryBindable
      include ServiceBiologicalIt::Bindable

      bind_as "llm-memory"

      # Ingest a new fact into the bronze tier.
      #
      # Expected payload keys:
      #   source:      String (required)
      #   source_type: String (required, one of LlmMemory::SOURCE_TYPES)
      #   raw_data:    Hash (required)
      def create(context_record)
        payload = context_record.payload
        fact = BronzeFact.create!(
          source: payload[:source],
          source_type: payload[:source_type],
          raw_data: payload[:raw_data],
          ingested_at: Time.current
        )
        Dry::Monads::Success(fact.as_json)
      end

      # Read a fact or insight by tier and id.
      #
      # Expected payload keys:
      #   tier: String ("bronze", "silver", or "gold")
      #   id:   Integer
      def read(context_record)
        payload = context_record.payload
        record = find_by_tier(payload[:tier], payload[:id])
        Dry::Monads::Success(record.as_json)
      end

      # Mark a gold insight as published to lifecycle.
      #
      # Expected payload keys:
      #   id: Integer (gold insight id)
      def update(context_record)
        insight = GoldInsight.find(context_record.payload[:id])
        insight.publish!
        Dry::Monads::Success(insight.as_json)
      end

      # Delete a fact or insight by tier and id.
      #
      # Expected payload keys:
      #   tier: String ("bronze", "silver", or "gold")
      #   id:   Integer
      def delete(context_record)
        payload = context_record.payload
        record = find_by_tier(payload[:tier], payload[:id])
        record.destroy
        Dry::Monads::Success(message: "Deleted")
      end

      # List facts or insights by tier with optional filters.
      #
      # Expected payload keys:
      #   tier:  String ("bronze", "silver", or "gold")
      #   limit: Integer (optional, default 100)
      def list(context_record)
        payload = context_record.payload
        records = model_for_tier(payload[:tier])
                    .order(created_at: :desc)
                    .limit(payload[:limit] || 100)
        Dry::Monads::Success(records.map(&:as_json))
      end

      # Run pipeline operations.
      #
      # Expected payload keys:
      #   operation: String ("collect", "process_bronze", "process_silver", "run_all")
      def execute(context_record)
        operation = context_record.payload[:operation]
        case operation
        when "collect"
          entries = collect_all
          Dry::Monads::Success(collected: entries.size)
        when "process_bronze"
          facts = Processors::BronzeProcessor.new.process(collect_all)
          Dry::Monads::Success(processed: facts.size)
        when "process_silver"
          bronze = BronzeFact.unprocessed
          silver = Processors::SilverProcessor.new.process(bronze)
          Dry::Monads::Success(processed: silver.size)
        when "run_all"
          run_full_pipeline
        else
          Dry::Monads::Failure(code: :unknown_operation, message: "Unknown operation: #{operation}")
        end
      end

      private

      def find_by_tier(tier, id)
        model_for_tier(tier).find(id)
      end

      def model_for_tier(tier)
        case tier.to_s
        when "bronze" then BronzeFact
        when "silver" then SilverFact
        when "gold"   then GoldInsight
        else raise LlmMemory::Error, "Unknown tier: #{tier}"
        end
      end

      def collect_all
        collectors = [
          Collectors::LlmStateCollector.new,
          Collectors::RailsLogCollector.new,
          Collectors::OpenTelemetryCollector.new
        ]
        collectors.flat_map(&:collect)
      end

      def run_full_pipeline
        raw = collect_all
        bronze = Processors::BronzeProcessor.new.process(raw)
        silver = Processors::SilverProcessor.new.process(bronze)
        gold = Processors::GoldProcessor.new.process(silver)
        Dry::Monads::Success(bronze: bronze.size, silver: silver.size, gold: gold.size)
      end
    end
  end
end
