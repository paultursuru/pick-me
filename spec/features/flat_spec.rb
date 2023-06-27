require 'rails_helper'
require_relative '../support/devise'

RSpec.feature "Flats", type: :feature do
  context "when logged in" do
    user = FactoryBot.create(:user)

    before(:each) do
      login_as(user, scope: :user)
    end

    scenario "a user can visit it's dashboard" do
      visit dashboard_path
      expect(page).to have_content("Hello, #{user.nickname}")
      expect(page).to have_selector "#flats"
      expect(page).to have_selector "#new_flat"
    end

    scenario "a user can create a flat and can now add rooms" do
      visit dashboard_path
      click_on "add a house/flat"
      fill_in "flat_name", with: "My flat"
      fill_in "flat_address", with: "My address"
      fill_in "flat_budget", with: 1000
      click_on "save"
      expect(page).to have_content("My flat")
      expect(page).to have_selector "#main-content"
      expect(page).to have_selector "#new_room"
    end

    scenario "a user can edit it's flat" do
      flat = create(:flat, user: user)
      visit dashboard_path
      expect(page).to have_selector "#flat_#{Flat.last.id}"
      click_on "edit"
      fill_in "flat_name", with: "My new flat"
      click_on "save"
      expect(page).to have_content("My new flat")
    end

    scenario "a user can go from dashboard to options through rooms and items frames" do
      flat = create(:flat, user: user)
      room = create(:room, flat: flat, kind: "bedroom")
      item = create(:item, room: room, name: "My item")
      option_1 = create(:option, item: item, name: "option 1")
      option_2 = create(:option, item: item, name: "option 2")

      visit dashboard_path
      flats_frame = find("turbo-frame#flats")
      expect(flats_frame).to be_present
      flat_frame = find("turbo-frame#flat_#{flat.id}")
      expect(flat_frame).to be_present

      click_on "see more" # link to flat frame

      rooms_frame = find("turbo-frame#rooms")
      expect(rooms_frame).to be_present
      room_frame = find("turbo-frame#room_#{room.id}")
      expect(room_frame).to be_present

      find("#room_link_#{room.id}").click # link to room frame

      items_frame = find("turbo-frame#items")
      expect(items_frame).to be_present
      item_frame = find("turbo-frame#item_#{item.id}")
      expect(item_frame).to be_present

      find("#item_link_#{item.id}").click # link to item frame

      options_frame = find("turbo-frame#options")
      expect(options_frame).to be_present
      option_1_frame = find("turbo-frame#option_#{option_1.id}")
      expect(option_1_frame).to be_present
      option_2_frame = find("turbo-frame#option_#{option_2.id}")
      expect(option_2_frame).to be_present
    end
  end
end
