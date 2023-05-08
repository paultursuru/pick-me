module ApplicationHelper
  def number_to_euros(number)
    return "-" unless number

    ActionController::Base.helpers.number_to_currency(number, unit: '€')
  end
end
