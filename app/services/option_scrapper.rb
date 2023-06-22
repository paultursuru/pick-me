class OptionScrapper < ApplicationService
  require "open-uri"
  require "nokogiri"

  def initialize(options = {})
    @url = options[:url]
  end

  def call
    scrapp_url
  end

  private

  def scrapp_url
    html_file = URI.open(@url).read
    html_doc = Nokogiri::HTML.parse(html_file)

    Option.new(
      name: html_doc.search(".pip-header-section__title--big").first.text.strip,
      description: html_doc.search(".pip-header-section__description").first.text.strip,
      price: html_doc.search(".pip-temp-price__integer").first.text.strip,
      image_url: html_doc.search(".pip-image").first.attr('src')
    )
  end
end
