module Spotlite
  # Represents a list of movies that are opening in theaters this week
  class OpeningThisWeek < InTheaters
    private
    
    # Returns the first out of two lists at http://www.imdb.com/movies-in-theaters/
    def list
      @list ||= page.css("div.sub-list").first
    end
  end
end
