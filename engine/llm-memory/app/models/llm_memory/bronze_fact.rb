# frozen_string_literal: true

module LlmMemory
  class BronzeFact < ApplicationRecord
    self.table_name = "lm_bronze_facts"

    validates :source, presence: true
    validates :source_type, presence: true, inclusion: { in: LlmMemory::SOURCE_TYPES }
    validates :raw_data, presence: true
    validates :ingested_at, presence: true

    scope :by_source_type, ->(type) { where(source_type: type) }
    scope :since, ->(time) { where(ingested_at: time..) }
    scope :recent, ->(limit = 10) { order(ingested_at: :desc).limit(limit) }
    scope :unprocessed, -> { where(created_at: ..SilverFact.minimum(:processed_at)) }
  end
end
