module Spotlite
  # Represents a list of movies coming soon
  class ComingSoon < List
    private
    
    # Returns an array of +Spotlite::Movie+ objects
    def parse_movies
      page.css("div.list_item").map do |node|
        imdb_id = node.at("a[itemprop='url']")['href'].parse_imdb_id
        title   = node.at("a[itemprop='url']").text.strip.strip_year
        year    = node.at("a[itemprop='url']").text.strip.split(" ").last.parse_year
        
        [imdb_id, title, year]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
        
    def open_page # :nodoc:
      Nokogiri::HTML(open("http://www.imdb.com/movies-coming-soon/",
                          "Accept-Language" => "en-us"))
    end
  end  
end
