class Item < ApplicationRecord
  belongs_to :flat
  has_many :options, dependent: :destroy

  enum importance: { low: 0, medium: 1, high: 2, urgent: 3 }

  validates :name, presence: true
  validates :importance, presence: true
  validates :importance, inclusion: { in: Item.importances.keys }

  scope :by_importance, -> { order(importance: :desc) }
  scope :ordered, -> { order(created_at: :desc)}
end
