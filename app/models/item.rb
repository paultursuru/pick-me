class Item < ApplicationRecord
  belongs_to :room

  has_many :options, dependent: :destroy

  enum importance: { low: 0, medium: 1, high: 2, urgent: 3 }

  validates :name, presence: true
  validates :importance, presence: true
  validates :importance, inclusion: { in: Item.importances.keys }

  scope :by_importance, -> { order(importance: :desc) }
  scope :ordered, -> { order(created_at: :desc) }

  def options_average_price
    return 0 if options.nil?

    options.map(&:price).sum.to_f / options.count
  end

  def lowest_highest_prices_with_currency
    prices = options.map(&:price)
    return nil if prices.empty?

    if prices.min == prices.max
      ActionController::Base.helpers.number_to_currency(prices.min, unit: '€')
    else
      ActionController::Base.helpers.number_to_currency(prices.min, unit: '€') + ' - ' + ActionController::Base.helpers.number_to_currency(prices.max, unit: '€')
    end
  end

  def five_star_options_total_price
    options.where(rating: 5).map(&:price).sum
  end
end
