module RoomsHelper
  def map_icons_for_kinds(kinds)
    kinds.map { |kind| map_icon_for_kind(kind) }
  end

  def button_icon_for_kind(kind)
    "<i class='fa-solid fa-plus mr-1'></i>#{icon_for_kind(kind)}</i><span class='hidden md:block'>#{kind_in_words(kind)}</span>"
  end

  def icon_for_kind(kind)
    case kind_in_words(kind)
    when "Bathroom"
      "<i class='fas fa-shower mr-1'></i>"
    when "Bedroom"
      "<i class='fas fa-bed mr-1'></i>"
    when "Living room"
      "<i class='fas fa-couch mr-1'></i>"
    when "Kitchen"
      "<i class='fas fa-utensils mr-1'></i>"
    when "Office"
      "<i class='fas fa-laptop mr-1'></i>"
    else
      "<i class='fa-solid fa-expand mr-1'></i>"
    end
  end

  def kind_in_words(kind)
    kind.gsub('_', ' ').capitalize
  end
end
