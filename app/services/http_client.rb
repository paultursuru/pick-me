class HttpClient
  USER_AGENTS = [
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5; rv:126.0) Gecko/20100101 Firefox/126.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
  ].freeze

  DEFAULT_TIMEOUT = 10 # seconds

  def self.call(url:, headers: {}, timeout: DEFAULT_TIMEOUT, proxy_url: ENV["HTTP_PROXY_URL"]) # rubocop:disable Metrics/MethodLength
    require "faraday"
    require "faraday/follow_redirects"
    require "faraday/cookie_jar"
    require "faraday/retry"
    require "zlib"
    require "stringio"

    root_referer = begin
      uri = URI.parse(url)
      uri.path = "/"
      uri.query = nil
      uri.fragment = nil
      uri.to_s
    rescue StandardError
      nil
    end

    default_headers = {
      "User-Agent" => USER_AGENTS.sample,
      "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
      "Accept-Language" => "en-US,en;q=0.9",
      "Accept-Encoding" => "gzip, deflate",
      "Referer" => root_referer
    }.compact

    faraday_options = {
      request: { timeout: timeout, open_timeout: 5 },
      proxy: (proxy_url if proxy_url.present?)
    }.compact

    connection = Faraday.new(nil, faraday_options) do |f|
      f.use :cookie_jar
      f.response :follow_redirects
      f.request :retry, max: 2, interval: 0.3, interval_randomness: 0.5, backoff_factor: 2,
                        methods: %i[get head], retry_statuses: [403, 429, 503]
      f.adapter Faraday.default_adapter
    end

    # Optional cookie priming: visit site root first to set cookies
    if root_referer && root_referer != url
      begin
        connection.get(root_referer) { |req| req.headers.update(default_headers.merge(headers)) }
      rescue StandardError
        # ignore
      end
    end

    response = connection.get(url) do |req|
      req.headers.update(default_headers.merge(headers))
    end

    raise Faraday::ClientError, "HTTP #{response.status}" if response.status >= 400

    body = response.body
    encoding = response.headers["content-encoding"]&.downcase

    case encoding
    when /gzip/
      body = Zlib::GzipReader.new(StringIO.new(body)).read
    when /deflate/
      begin
        body = Zlib::Inflate.inflate(body)
      rescue Zlib::DataError
        body = Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(body)
      end
    end

    body.force_encoding("UTF-8")
    body
  end
end


