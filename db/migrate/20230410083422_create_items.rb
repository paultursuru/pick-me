class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :importance, default: 0
      t.references :flat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
