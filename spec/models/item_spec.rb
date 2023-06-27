require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it "should have a valid factory" do
      expect(build(:item)).to be_valid
    end
  end

  describe ".options_average_price" do
    it "should return 0 if there are no options" do
      item = create(:item)

      expect(item.options_average_price).to eq(0)
    end

    it "should return the sum of all options prices" do
      item = create(:item)
      option_1 = create(:option, item: item, price: 10)
      option_2 = create(:option, item: item, price: 20)

      expect(item.options_average_price).to eq(15)
    end
  end

  describe ".lowest_highest_prices_with_currency" do
    it "should return nil if there are no options" do
      item = create(:item)

      expect(item.lowest_highest_prices_with_currency).to eq(nil)
    end

    it "should return the lowest and highest price with currency if there at least one option" do
      item = create(:item)
      option_1 = create(:option, item: item, price: 10)
      option_2 = create(:option, item: item, price: 29.90)
      option_3 = create(:option, item: item, price: 20)

      expect(item.lowest_highest_prices_with_currency).to eq("10 € - 29,9 €")
    end

    it "should return only one price if there is one option" do
      item = create(:item)
      option_1 = create(:option, item: item, price: 10)

      expect(item.lowest_highest_prices_with_currency).to eq("10 €")
    end
  end

  describe ".five_star_options_total_price" do
    it "should return 0 if there are no options" do
      item = create(:item)

      expect(item.five_star_options_total_price).to eq(0)
    end

    it "should return the sum of all five star options prices" do
      item = create(:item)
      option_1 = create(:option, item: item, price: 10)
      vote_1 = create(:vote, option: option_1, stars: 5)
      option_2 = create(:option, item: item, price: 20)
      vote_2 = create(:vote, option: option_2, stars: 5)

      expect(item.five_star_options_total_price).to eq(30)
    end
  end
end
