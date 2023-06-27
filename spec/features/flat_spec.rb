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
  end
end
