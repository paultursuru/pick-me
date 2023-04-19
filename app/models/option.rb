class Option < ApplicationRecord
  belongs_to :item

  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  has_one_attached :image

  def price_with_currency
    ActionController::Base.helpers.number_to_currency(price, unit: '€')
  end
end
