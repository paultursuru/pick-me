class Room < ApplicationRecord
  belongs_to :flat
  has_many :items, dependent: :destroy
  has_many :options, through: :items

  after_create :set_name, if: -> { name.nil? }

  enum kind: { other: 0, bathroom: 1, bedroom: 2, living_room: 3, kitchen: 4, office: 5 }

  scope :ordered, -> { order(kind: :desc) }

  def set_name
    room_count = flat.rooms.where(kind: kind).count
    room_number = [" - ", room_count].join if room_count > 1
    update(name: "#{kind.gsub("_", " ")}#{ room_number }")
  end

  def items_average_price
    return 0 if options.empty?

    items.map(&:options_average_price).sum
  end
end
