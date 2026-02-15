# frozen_string_literal: true

module LlmMemory
  class SilverFact < ApplicationRecord
    self.table_name = "lm_silver_facts"

    validates :bronze_fact_ids, presence: true
    validates :normalized_data, presence: true
    validates :correlation_id, presence: true
    validates :entity_type, presence: true
    validates :processed_at, presence: true

    scope :by_entity_type, ->(type) { where(entity_type: type) }
    scope :since, ->(time) { where(processed_at: time..) }
    scope :recent, ->(limit = 10) { order(processed_at: :desc).limit(limit) }
    scope :unprocessed, -> { where(created_at: ..GoldInsight.minimum(:refined_at)) }
  end
end
