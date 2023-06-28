require 'rails_helper'
require_relative '../support/devise'

RSpec.feature "Turbo Frames", type: :feature, js: true do
  context "when logged in" do
    user = FactoryBot.create(:user)
    flat = FactoryBot.create(:flat, user: user)
    room = FactoryBot.create(:room, flat: flat)
    item = FactoryBot.create(:item, room: room)
    option_1 = FactoryBot.create(:option, item: item)
    option_2 = FactoryBot.create(:option, item: item)

    before(:each) do
      login_as(user, scope: :user)
    end

    scenario "a user can go from dashboard to a flat and from here all the way to options through turbo frames" do
      visit dashboard_path
      flats_frame = find("turbo-frame#flats")
      expect(flats_frame).to be_present
      flat_frame = find("turbo-frame#flat_#{flat.id}")
      expect(flat_frame).to be_present

      click_on "see more" # link to flat frame
      expect(page).to have_current_path(flat_path(flat))

      rooms_frame = find("turbo-frame#rooms")
      expect(rooms_frame).to be_present
      room_frame = find("turbo-frame#room_#{room.id}", visible: :all)
      expect(room_frame).to be_present

      room_frame.click # link to room frame
      expect(page).to have_current_path(flat_path(flat))

      items_frame = find("turbo-frame#items")
      expect(items_frame).to be_present
      item_frame = find("turbo-frame#item_#{item.id}")
      expect(item_frame).to be_present

      find(:css, "#item_link_#{item.id}").click # link to item frame
      expect(page).to have_current_path(flat_path(flat))

      options_frame = find("turbo-frame#options")
      expect(options_frame).to be_present
      option_1_frame = find("turbo-frame#option_#{option_1.id}")
      expect(option_1_frame).to be_present
      option_2_frame = find("turbo-frame#option_#{option_2.id}")
      expect(option_2_frame).to be_present
    end
  end
end
