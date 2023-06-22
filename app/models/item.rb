class Item < ApplicationRecord
  belongs_to :room

  has_many :options, dependent: :destroy

  enum importance: { low: 0, medium: 1, high: 2, urgent: 3 }

  validates :name, presence: true
  validates :importance, presence: true
  validates :importance, inclusion: { in: Item.importances.keys }

  scope :by_importance, -> { order(importance: :desc) }
  scope :ordered, -> { order(created_at: :desc) }

  def flat
    room.flat
  end

  def options_average_price
    return 0 if (options.nil? || options.empty?)

    options.map(&:price).sum.to_f / options.count
  end

  def lowest_highest_prices_with_currency
    prices = options.map(&:price)
    return nil if prices.empty?

    if prices.min == prices.max
      ApplicationController.helpers.number_to_euros(prices.min)
    else
      ApplicationController.helpers.number_to_euros(prices.min) + ' - ' + ApplicationController.helpers.number_to_euros(prices.max)
    end
  end

  def five_star_options_total_price
    options.where(rating: 5).map(&:price).sum
  end
end
