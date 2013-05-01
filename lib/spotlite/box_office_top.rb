module Spotlite
  # Represents a list of this week's top 10 box office
  class BoxOfficeTop < InTheaters
    private
    
    # Returns the last out of two lists at http://www.imdb.com/movies-in-theaters/
    def list
      @list ||= page.css("div.sub-list").last
    end
  end
end
