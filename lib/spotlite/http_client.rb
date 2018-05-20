class HtmlParserIncluded < HTTParty::Parser
  SupportedFormats.merge!("text/html" => :html)

  def html
    Nokogiri::HTML(body)
  end
end

module Spotlite
  class Client
    include HTTParty
    parser HtmlParserIncluded

    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1 Safari/605.1.15"

    headers "Accept-Language" => "en-US,en;q=0.5", "User-Agent" => USER_AGENT
  end
end
