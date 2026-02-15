# frozen_string_literal: true

class CreateLmGoldInsights < ActiveRecord::Migration[7.1]
  def change
    create_table :lm_gold_insights do |t|
      t.json :silver_fact_ids, null: false, default: []
      t.string :insight_type, null: false
      t.text :summary, null: false
      t.float :score, null: false, default: 0.0
      t.json :metadata, default: {}
      t.boolean :lifecycle_published, null: false, default: false
      t.datetime :refined_at, null: false

      t.timestamps
    end

    add_index :lm_gold_insights, :insight_type
    add_index :lm_gold_insights, :score
    add_index :lm_gold_insights, :lifecycle_published
    add_index :lm_gold_insights, :refined_at
  end
end
