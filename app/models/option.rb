class Option < ApplicationRecord
  attr_accessor :image_url # needed for scrapper creation

  belongs_to :item
  has_many :votes, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  scope :sort_by_price, -> { order(price: :desc) }
  scope :favorited, -> { select { |opt| opt.average_stars == 5 } }
  scope :top_voted, -> { select { |opt| opt.average_stars >= 3 } }

  has_one_attached :image

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
