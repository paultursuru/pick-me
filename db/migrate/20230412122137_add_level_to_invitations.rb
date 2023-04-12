class AddLevelToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_column :invitations, :level, :integer, default: 0
  end
end
