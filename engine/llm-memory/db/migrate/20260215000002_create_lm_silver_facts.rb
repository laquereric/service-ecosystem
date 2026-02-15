# frozen_string_literal: true

class CreateLmSilverFacts < ActiveRecord::Migration[7.1]
  def change
    create_table :lm_silver_facts do |t|
      t.json :bronze_fact_ids, null: false, default: []
      t.json :normalized_data, null: false
      t.string :correlation_id, null: false
      t.string :entity_type, null: false
      t.datetime :processed_at, null: false

      t.timestamps
    end

    add_index :lm_silver_facts, :correlation_id
    add_index :lm_silver_facts, :entity_type
    add_index :lm_silver_facts, :processed_at
  end
end
