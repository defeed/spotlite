module Spotlite

  # Represents a list of movies
  # Search results, movies a person participated in, etc.
  class List
    # Returns an array of +Spotlite::Movie+ objects
    def movies
      @movies ||= parse_movies
    end
  end

end
