require "cgi"
module Spotlite

  class Search < List
    attr_reader :query
    
    SKIP = ["(TV Episode)", "(TV Series)", "(TV Movie)", "(Video)", "(Short)", "(Video Game)"]
    
    # Initialize a +Search+ object with string search query
    def initialize(query)
      @query = query
    end
    
    private
    
    def page # :nodoc:
      @page ||= open_page
    end
    
    # Searches for a table containing movie titles and parses it.
    # Returns an array of +Spotlite::Movie+ objects
    # Returns empty array if no results found
    def parse_movies
      table = page.at("a[name='tt']").parent.parent.at("table.findList") rescue nil
      if !table.nil?
        table.css("td.result_text").reject do |node|
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
      else
        return []
      end
    end
    
    def open_page # :nodoc:
      Nokogiri::HTML(open("http://www.imdb.com/find?q=#{CGI::escape(@query)}&s=all",
                          "Accept-Language" => "en-us"))
    end
  end

end
