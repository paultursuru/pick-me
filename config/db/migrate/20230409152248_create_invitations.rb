class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :flat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
