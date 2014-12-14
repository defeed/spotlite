class HtmlParserIncluded < HTTParty::Parser
  SupportedFormats.merge!('text/html' => :html)

  def html
    Nokogiri::HTML(body)
  end
end

module Spotlite
  class Client
    include HTTParty
    parser HtmlParserIncluded

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.77.4 (KHTML, like Gecko) Version/7.0.5 Safari/537.77.4'

    headers 'Accept-Language' => 'en-US,en;q=0.5', 'User-Agent' => USER_AGENT
  end
end
