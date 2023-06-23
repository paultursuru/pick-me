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

    case get_domain(@url)
    when "ikea"
      Option.new with_ikea(html_doc)
    when "habitat"
      Option.new with_habitat(html_doc)
    else
      Option.new with_og(html_doc)
    end
  end

  def get_domain(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    (host.start_with?('www.') ? host[4..-1] : host).split(".").first
  end

  def with_ikea(html_doc)
    {
      name: html_doc.search(".pip-header-section__title--big").first.text.strip,
      description: html_doc.search(".pip-header-section__description").first.text.strip,
      price: html_doc.search(".pip-temp-price__integer").first.text.strip,
      image_url: html_doc.search(".pip-image").first.attr('src')
    }
  end

  def with_habitat(html_doc)
    {
      name: html_doc.search(".title-deco-4").first.text.strip,
      description: html_doc.search(".product-wording-top__content").first.text.strip,
      price: html_doc.search("meta[property='product:price:amount']").first.attributes["content"].value,
      image_url: html_doc.css("meta[property='og:image']").first.attributes["content"].value
    }
  end

  def with_og(html_doc)
    {
      name: html_doc.search("meta[property='og:title']").first.attributes["content"].value,
      description: html_doc.search("meta[property='og:description']").first.attributes["content"].value,
      price: html_doc.search("meta[property='og:price:amount']").first.attributes["content"].value,
      image_url: html_doc.css("meta[property='og:image']").first.attributes["content"].value
    }
  end
end
