class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :flat

  attr_accessor :email # needed for the form

  validates :user, uniqueness: { scope: :flat }

  enum status: { pending: 0, accepted: 1, declined: 2 }
  enum level: { normal: 0, admin: 1 }

  scope :pending_or_accepted, -> { where(status: [0, 1]) }
end
