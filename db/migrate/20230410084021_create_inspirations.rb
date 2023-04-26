class CreateInspirations < ActiveRecord::Migration[7.0]
  def change
    create_table :inspirations do |t|
      t.string :title
      t.string :description
      t.references :flat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
