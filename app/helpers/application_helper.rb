module ApplicationHelper
  def number_to_euros(number)
    return "-" unless number

    number_to_currency(number, unit: '€', separator: ',', delimiter: '', format: '%n %u', strip_insignificant_zeros: true)
  end

  def secure_url_for(url)
    return "/404.html" unless url.present?

    require 'uri'
    uri = URI(url)
    uri.scheme = "https"
    uri.to_s
  end
end
