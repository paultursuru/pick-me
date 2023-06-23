module OptionsHelper
  def stars_for_option_in_icons(option_stars)
    return '' if option_stars.zero?
    content_tag(:span, class: 'flex justify-center items-center relative ml-2') do
      content_tag(:i, '', class: 'fas fa-star text-yellow-500 absolute text-3xl') +
      content_tag(:p, option_stars, class: 'absolute text-sm text-yellow-100')
    end
  end

  def domain_for(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    (host.start_with?('www.') ? host[4..-1] : host).split(".").first.gsub("_", " ")
  end
end
