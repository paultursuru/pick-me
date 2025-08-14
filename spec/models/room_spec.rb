require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "validations" do
    it "should have a valid factory" do
      expect(build(:room)).to be_valid
    end
  end

  describe ".items_average_price" do
    it "should return 0 if there are no items" do
      room = create(:room)

      expect(room.items_average_price).to eq(0)
    end

    it "should return the sum of all items options_average_price" do
      room = create(:room)
      item = create(:item, room: room)
      option = create(:option, item: item)

      expect(room.items_average_price).to eq(option.price)
    end
  end

  describe ".set_name" do
    it "should set the name of the room when no name is given (for quick room creation)" do
      room = create(:room, kind: :bedroom)

      expect(room.name).to eq("bedroom")
    end

    it "should set the name of the room with a number if there are more than one room of the same kind in the same flat" do
      flat = create(:flat)
      create(:room, kind: 2, flat: flat)
      room = create(:room, kind: 2, flat: flat)

      expect(room.name).to eq("bedroom 2")
    end
  end
end
