module Spotlite

  # Represents a list of movies
  # Search results, movies a person participated in, etc.
  class List
    # Returns an array of +Spotlite::Movie+ objects
    def movies
      @movies ||= parse_movies
    end
    
    private
    
    def page # :nodoc:
      @page ||= open_page
    end
  end

end
