class Flat < ApplicationRecord
  belongs_to :user
  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user
  has_many :items, dependent: :destroy
  has_many :options, through: :items
  has_many :inspirations, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  has_one_attached :photo

  # invited users with their level
  def invited_admin_users
    invited_users.where(invitations: { level: 1 })
  end

  # invited users with their status
  scope :invited_users_with_status_pending, -> { joins(:invitations).where(invitations: { status: 0 }) }
  scope :invited_users_with_status_accepted, -> { joins(:invitations).where(invitations: { status: 1 }) }
  scope :invited_users_with_status_declined, -> { joins(:invitations).where(invitations: { status: 2 }) }
end
