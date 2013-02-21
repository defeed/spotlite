require "cgi"
module Spotlite

  class Search < List
    attr_reader :query
    
    SKIP = ["(TV Episode)", "(TV Series)", "(TV Movie)", "(Video)", "(Short)", "(Video Game)"]
    
    def initialize(query)
      @query = query
    end
    
    private
    
    def page
      @page ||= open_page
    end
    
    def parse_movies
      page.at("table.findList").css("td.result_text").reject do |node|
        # search results will only include movies
        SKIP.any? { |skipped| node.text.include? skipped }
      end.map do |node|
        imdb_id = node.at("a[href^='/title/tt']")['href'].parse_imdb_id
        title   = node.at("a").text.strip
        year    = node.children.last.text.parse_year
        
        [imdb_id, title, year]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
    
    def open_page
      Nokogiri::HTML(open("http://www.imdb.com/find?q=#{CGI::escape(@query)}&s=all",
                          "Accept-Language" => "en-us"))
    end
  end

end
