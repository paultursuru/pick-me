class OptionScrapper < ApplicationService
  require "open-uri"
  require "nokogiri"

  def initialize(options = {})
    @url      = options[:url]
    @domain   = get_domain(@url)
    @html_doc = nil
    @error    = nil
  end

  def call
    scrapp_url       # if scrap works
    if @error.nil?
      build_option   # build and return option
    else             # some website block scraping and we get a OpenURI::HTTPError (403 Forbidden)
      {
        status: "403",
        website: @domain
      }
    end
  end

  private

  def scrapp_url
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:100.0) Gecko/20100101 Firefox/100.0"
    begin # try to OpenURI with a user-agent
      html_file = URI.open(@url, "User-Agent" => user_agent).read
    rescue OpenURI::HTTPError => error
      # Handle HTTP errors here
      @error = error
    end
    @html_doc = Nokogiri::HTML.parse(html_file)
  end

  def build_option
    case @domain
    when "ikea"
      Option.new with_ikea
    when "habitat"
      Option.new with_habitat
    else
      Option.new with_og
    end
  end

  def get_domain(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    @domain = (host.start_with?('www.') ? host[4..-1] : host).split(".").first
  end

  def with_ikea
    {
      name: @html_doc.search(".pip-header-section__title--big").first.text.strip,
      description: @html_doc.search(".pip-header-section__description").first.text.strip,
      price: @html_doc.search(".pip-temp-price__integer").first.text.strip,
      image_url: @html_doc.search(".pip-image").first.attr('src')
    }
  end

  def with_habitat
    {
      name: @html_doc.search(".title-deco-4").first.text.strip,
      description: @html_doc.search(".product-wording-top__content").first.text.strip,
      price: @html_doc.search("meta[property='product:price:amount']").first.attributes["content"].value,
      image_url: @html_doc.css("meta[property='og:image']").first.attributes["content"].value
    }
  end

  def with_og
    {
      name: safe_name,
      description: safe_description,
      price: safe_price,
      image_url: safe_image_url
    }
  end

  def safe_name
    if @html_doc.search("title")
      @html_doc.search("title").first.content
    elsif @html_doc.search("meta[property='og:title']")
      @html_doc.search("meta[property='og:title']").first.attributes["content"].value
    else
      error_for("title")
    end
  end

  def safe_description
    if @html_doc.search("meta[name='description']")
      @html_doc.search("meta[name='description']").first.attributes["content"].value
    elsif @html_doc.search("meta[property='og:description']")
      @html_doc.search("meta[property='og:description']").first.attributes["content"].value
    else
      error_for("description")
    end
  end

  def safe_price
    if !@html_doc.search("meta[name='price']").empty?
      @html_doc.search("meta[name='price']").first.attributes["content"].value
    elsif !@html_doc.search("meta[property='og:price']").empty?
      @html_doc.search("meta[property='og:price']").first.attributes["content"].value
    elsif !@html_doc.search("meta[property='product:price:amount']").empty?
      @html_doc.search("meta[property='product:price:amount']").first.attributes["content"].value
    else
      error_for("price")
    end
  end

  def safe_image_url
    if !@html_doc.search("meta[property='image']").empty?
      @html_doc.search("meta[property='image']").first.attributes["content"].value
    elsif !@html_doc.search("meta[property='og:image']").empty?
      @html_doc.search("meta[property='og:image']").first.attributes["content"].value
    else
      error_for("image")
    end
  end

  def error_for(keyword)
    "no #{keyword} found"
  end
end
