module Spotlite
  # Represents a list of movies in theaters: opening this week, and this week's box office top 10
  class InTheaters < List
    private
    
    # Returns an array of +Spotlite::Movie+ objects
    def parse_movies
      # +list+ method is defined in descendant classes
      list.css("div.list_item").map do |node|
        imdb_id = node.at("a[itemprop='url']")['href'].parse_imdb_id
        title   = node.at("a[itemprop='url']").text.strip.strip_year
        year    = node.at("a[itemprop='url']").text.strip.split(" ").last.parse_year
        
        [imdb_id, title, year]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
        
    def open_page # :nodoc:
      Nokogiri::HTML(open("http://www.imdb.com/movies-in-theaters/",
                          "Accept-Language" => "en-us"))
    end
  end  
end
