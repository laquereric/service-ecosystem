class CreateRepositories < ActiveRecord::Migration[8.0]
  def change
    create_table :repositories do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.string :path, null: false

      t.timestamps
    end
  end
end
