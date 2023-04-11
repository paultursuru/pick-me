class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.string :name
      t.string :size
      t.string :description
      t.string :url
      t.float  :price
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
