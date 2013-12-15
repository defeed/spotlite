module Spotlite
  class Top < List
    private
    
    # Returns an array of +Spotlite::Movie+ objects
    def parse_movies
      page.css("table.chart td.titleColumn").map do |cell|
        imdb_id = cell.at("a[href^='/title/tt']")['href'].parse_imdb_id
        title   = cell.at("a[href^='/title/tt']").text.strip
        year    = cell.at("span.secondaryInfo").text.parse_year
        
        [imdb_id, title, year]
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
