class AddReferenceToRoomInItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :room, foreign_key: true

    Item.all.each do |item|
      other = Room.create(name: 'other', flat: item.flat)
      item.room_id = other.id
      item.save!
    end
  end
end
