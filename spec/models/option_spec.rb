require 'rails_helper'

RSpec.describe Option, type: :model do
  describe "validations" do
    it "should have a valid factory" do
      expect(build(:option)).to be_valid
    end
  end
end
