class Option < ApplicationRecord
  belongs_to :item
  has_many :votes, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  has_one_attached :image

  def price_with_currency
    ActionController::Base.helpers.number_to_currency(price, unit: '€')
  end

  def votes_count
    votes.count
  end

  def average_stars
    return 0 if votes_count.zero?

    votes.sum(:stars) / votes_count
  end

  def vote_by(user)
    votes.find_by(user: user)
  end

  def stars_by(user)
    votes_by(user).first.stars
  end
end
