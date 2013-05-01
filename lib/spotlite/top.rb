module Spotlite
  class Top < List
    private
    
    # Returns an array of +Spotlite::Movie+ objects
    def parse_movies
      page.css("table a[href^='/title/tt']").map do |node|
        imdb_id = node['href'].parse_imdb_id
        title   = node.text.strip
        
        [imdb_id, title]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
    
    def open_page # :nodoc:
      Nokogiri::HTML(open("http://www.imdb.com/chart/top",
                          "Accept-Language" => "en-us"))
    end
  end
end
