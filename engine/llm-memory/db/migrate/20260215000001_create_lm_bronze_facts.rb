# frozen_string_literal: true

class CreateLmBronzeFacts < ActiveRecord::Migration[7.1]
  def change
    create_table :lm_bronze_facts do |t|
      t.string :source, null: false
      t.string :source_type, null: false
      t.json :raw_data, null: false
      t.datetime :ingested_at, null: false

      t.timestamps
    end

    add_index :lm_bronze_facts, :source_type
    add_index :lm_bronze_facts, :ingested_at
  end
end
