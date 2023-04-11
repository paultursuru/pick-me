module ItemsHelper
  def color_for_importance(level)
    case level
    when "low"
      "emerald"
    when "medium"
      "yellow"
    when "high"
      "orange"
    when "urgent"
      "red"
    end
  end
end
