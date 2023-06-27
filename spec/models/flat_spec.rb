require 'rails_helper'

RSpec.describe Flat, type: :model do
  describe "validations" do
    it "should have a valid factory" do
      expect(build(:flat)).to be_valid
    end
  end

  describe ".estimated_total_cost_for_all_rooms" do
    it "should return 0 if the flat has no room" do
      flat = create(:flat, user: create(:user))
      expect(flat.estimated_total_cost_for_all_rooms).to eq(0)
    end

    it "should return the sum of all rooms estimated cost" do
      flat = create(:flat, user: create(:user))
      room = create(:room, flat: flat)
      item = create(:item, room: room)
      option = create(:option, item: item)
      expect(flat.estimated_total_cost_for_all_rooms).to eq(option.price)
    end
  end

  describe ".budget_left" do
    it "should return 0 if the flat has no budget" do
      flat = create(:flat, user: create(:user))
      expect(flat.budget_left).to eq(flat.budget)
    end

    it "should return the budget left" do
      flat = create(:flat, user: create(:user))
      room = create(:room, flat: flat)
      item = create(:item, room: room)
      option = create(:option, item: item)
      expect(flat.budget_left).to eq(flat.budget - option.price)
    end
  end

  describe ".priciest_item" do
    it "should return nil if the flat has no item" do
      flat = create(:flat, user: create(:user))
      expect(flat.priciest_item).to eq(nil)
    end

    it "should return the priciest item" do
      flat = create(:flat, user: create(:user))
      room = create(:room, flat: flat)
      item = create(:item, room: room)
      option = create(:option, item: item)
      expect(flat.priciest_item).to eq(option)
    end
  end

  describe ".invited_admin_users" do
    it "should return the invited admin users" do
      flat = create(:flat, user: create(:user))
      invited_user = create(:user)
      create(:invitation, flat: flat, user: invited_user, level: 1)
      expect(flat.invited_admin_users).to eq([invited_user])
    end
  end

  describe ".invited_normal_users" do
    it "should return the invited normal users" do
      flat = create(:flat, user: create(:user))
      invited_user = create(:user)
      create(:invitation, flat: flat, user: invited_user, level: 0)
      expect(flat.invited_normal_users).to eq([invited_user])
    end
  end

  describe ".invited_accepted_users" do
    it "should return the invited accepted users" do
      flat = create(:flat, user: create(:user))
      invited_user = create(:user)
      create(:invitation, flat: flat, user: invited_user, status: 1)
      expect(flat.invited_accepted_users).to eq([invited_user])
    end
  end

  describe ".invited_pending_users" do
    it "should return the invited pending users" do
      flat = create(:flat, user: create(:user))
      invited_user = create(:user)
      create(:invitation, flat: flat, user: invited_user, status: 0)
      expect(flat.invited_pending_users).to eq([invited_user])
    end
  end

  describe ".invited_declined_users" do
    it "should return the invited declined users" do
      flat = create(:flat, user: create(:user))
      invited_user = create(:user)
      create(:invitation, flat: flat, user: invited_user, status: 2)
      expect(flat.invited_declined_users).to eq([invited_user])
    end
  end
end
