class AddReferenceToRoomInItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :room, foreign_key: true
    add_column :rooms, :kind, :integer, default: 0, null: false

    Item.all.each do |item|
      other = Room.create(name: 'other', flat_id: item.flat.id)
      item.room_id = other.id
      item.save!
    end
  end
end
