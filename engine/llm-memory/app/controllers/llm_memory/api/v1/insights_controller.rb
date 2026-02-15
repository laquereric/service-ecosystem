# frozen_string_literal: true

module LlmMemory
  module Api
    module V1
      class InsightsController < ActionController::API
        before_action :set_insight, only: %i[show publish]

        def index
          insights = GoldInsight.order(refined_at: :desc)
          insights = insights.by_type(params[:insight_type]) if params[:insight_type]
          insights = insights.above_score(params[:min_score].to_f) if params[:min_score]
          insights = insights.published if params[:published] == "true"
          insights = insights.unpublished if params[:published] == "false"
          insights = insights.limit(params[:limit] || 100)

          render json: insights.map { |i| insight_json(i) }
        end

        def show
          render json: insight_json(@insight)
        end

        def publish
          @insight.publish!
          render json: insight_json(@insight)
        end

        private

        def set_insight
          @insight = GoldInsight.find(params[:id])
        end

        def insight_json(insight)
          {
            id: insight.id,
            silver_fact_ids: insight.silver_fact_ids,
            insight_type: insight.insight_type,
            summary: insight.summary,
            score: insight.score,
            metadata: insight.metadata,
            lifecycle_published: insight.lifecycle_published,
            refined_at: insight.refined_at,
            created_at: insight.created_at
          }
        end
      end
    end
  end
end
