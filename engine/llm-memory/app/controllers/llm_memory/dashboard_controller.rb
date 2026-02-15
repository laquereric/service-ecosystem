# frozen_string_literal: true

module LlmMemory
  class DashboardController < ApplicationController
    def show
      @bronze_count = BronzeFact.count
      @silver_count = SilverFact.count
      @gold_count = GoldInsight.count

      @recent_bronze = BronzeFact.recent(5)
      @recent_silver = SilverFact.recent(5)
      @recent_gold = GoldInsight.recent(5)

      @source_type_counts = BronzeFact.group(:source_type).count
      @insight_type_counts = GoldInsight.group(:insight_type).count
      @published_count = GoldInsight.published.count
      @unpublished_count = GoldInsight.unpublished.count
    end
  end
end
