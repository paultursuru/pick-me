class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.integer :stars, null: false

      t.timestamps
    end
  end
end
