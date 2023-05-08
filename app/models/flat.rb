class Flat < ApplicationRecord
  belongs_to :user
  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user
  has_many :rooms, dependent: :destroy
  has_many :items, through: :rooms
  has_many :options, through: :items
  has_many :inspirations, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  has_one_attached :photo

  def estimated_total_cost_for_all_rooms
    return 0 if rooms.empty?

    rooms.map(&:room_average_price).sum
  end

  def estimated_total_cost_for_all_rooms_with_currency
    ActionController::Base.helpers.number_to_currency(estimated_total_cost_for_all_rooms, unit: '€')
  end

  def budget_with_currency
    return 0 if budget.nil?

    ActionController::Base.helpers.number_to_currency(budget, unit: '€')
  end

  def budget_left
    return 0 if budget.nil?

    left = budget - estimated_total_cost_for_all_rooms
  end

  def priciest_item
    return nil if items.empty?

    items.sort_by_avg_price.first
  end

  # invited users with their level
  def invited_admin_users
    invited_users.where(invitations: { level: 1 })
  end

  def invited_accepted_users
    invited_users.where(invitations: { status: 1 })
  end

  # invited users with their status
  scope :invited_users_with_status_pending, -> { joins(:invitations).where(invitations: { status: 0 }) }
  scope :invited_users_with_status_accepted, -> { joins(:invitations).where(invitations: { status: 1 }) }
  scope :invited_users_with_status_declined, -> { joins(:invitations).where(invitations: { status: 2 }) }
end
