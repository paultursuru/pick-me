class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :flat

  attr_accessor :email
end
