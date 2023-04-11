class Flat < ApplicationRecord
  belongs_to :user
  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user
  has_many :items, dependent: :destroy
  has_many :options, through: :items
  has_many :inspirations, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

end
