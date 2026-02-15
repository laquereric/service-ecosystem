# frozen_string_literal: true

module LlmMemory
  class GoldInsight < ApplicationRecord
    self.table_name = "lm_gold_insights"

    validates :silver_fact_ids, presence: true
    validates :insight_type, presence: true
    validates :summary, presence: true
    validates :score, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0 }
    validates :refined_at, presence: true

    scope :by_type, ->(type) { where(insight_type: type) }
    scope :published, -> { where(lifecycle_published: true) }
    scope :unpublished, -> { where(lifecycle_published: false) }
    scope :above_score, ->(threshold) { where(score: threshold..) }
    scope :recent, ->(limit = 10) { order(refined_at: :desc).limit(limit) }

    def publish!
      update!(lifecycle_published: true)
    end
  end
end
