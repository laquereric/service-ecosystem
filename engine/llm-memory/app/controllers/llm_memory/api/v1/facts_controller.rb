# frozen_string_literal: true

module LlmMemory
  module Api
    module V1
      class FactsController < ActionController::API
        def bronze
          facts = BronzeFact.order(ingested_at: :desc)
          facts = facts.by_source_type(params[:source_type]) if params[:source_type]
          facts = facts.since(Time.parse(params[:since])) if params[:since]
          facts = facts.limit(params[:limit] || 100)

          render json: facts.map { |f| bronze_json(f) }
        end

        def silver
          facts = SilverFact.order(processed_at: :desc)
          facts = facts.by_entity_type(params[:entity_type]) if params[:entity_type]
          facts = facts.since(Time.parse(params[:since])) if params[:since]
          facts = facts.limit(params[:limit] || 100)

          render json: facts.map { |f| silver_json(f) }
        end

        def show_bronze
          fact = BronzeFact.find(params[:id])
          render json: bronze_json(fact)
        end

        def show_silver
          fact = SilverFact.find(params[:id])
          render json: silver_json(fact)
        end

        private

        def bronze_json(fact)
          {
            id: fact.id,
            source: fact.source,
            source_type: fact.source_type,
            raw_data: fact.raw_data,
            ingested_at: fact.ingested_at,
            created_at: fact.created_at
          }
        end

        def silver_json(fact)
          {
            id: fact.id,
            bronze_fact_ids: fact.bronze_fact_ids,
            normalized_data: fact.normalized_data,
            correlation_id: fact.correlation_id,
            entity_type: fact.entity_type,
            processed_at: fact.processed_at,
            created_at: fact.created_at
          }
        end
      end
    end
  end
end
