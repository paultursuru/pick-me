require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe "validations" do
    it "should have a valid factory" do
      expect(build(:invitation)).to be_valid
    end
  end
end
