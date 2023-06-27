require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe "validations" do
    it "should have a valid factory" do
      expect(build(:vote)).to be_valid
    end
  end
end
