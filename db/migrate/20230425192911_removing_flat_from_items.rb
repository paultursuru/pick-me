class RemovingFlatFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_reference :items, :flat, foreign_key: true
    change_column_null :items, :room_id, false
  end
end
