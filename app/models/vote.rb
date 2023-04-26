class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :option

  validates :stars, presence: true
  validates :stars, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  validates :user, uniqueness: { scope: :option }

  scope :by_user, ->(user) { find_by(user: user) }

  def item
    option.item
  end

  def room
    item.room
  end
end
