module Spotlite
  class Movie
    attr_accessor :imdb_id

    def initialize(imdb_id, title = nil, year = nil)
      @imdb_id = "%07d" % imdb_id.to_i
      @title   = title
      @year    = year
      @url     = "http://www.imdb.com/title/tt#{@imdb_id}/"
    end

    def title
      @title ||= parser.parse_title
    end

    def original_title
      @original_title ||= parser.parse_original_title
    end

    def year
      @year ||= parser.parse_year
    end

    def rating
      @rating ||= parser.parse_rating
    end

    def votes
      @votes ||= parser.parse_votes
    end

    def metascore
      @metascore ||= parser.parse_metascore
    end

    def description
      @description ||= parser.parse_description
    end

    def storyline
      @storyline ||= parser.parse_storyline
    end

    def content_rating
      @content_rating ||= parser.parse_content_rating
    end

    def genres
      @genres ||= parser.parse_genres
    end

    def countries
      @countries ||= parser.parse_countries
    end

    def languages
      @languages ||= parser.parse_languages
    end

    def runtime
      @runtime ||= parser.parse_runtime
    end

    def stars
      @stars ||= parser.parse_stars
    end

    def recommended_movies
      @recommended_movies ||= parser.parse_recommended_movies
    end

    def poster_url
      @poster_url ||= parser.parse_poster_url
    end

    def plot_summaries
      @plot_summaries ||= parser.parse_summaries
    end

    def keywords
      @keywords ||= parser.parse_keywords
    end

    def trivia
      @trivia ||= parser.parse_trivia
    end

    def taglines
      @taglines ||= parser.parse_taglines
    end

    def alternative_titles
      @alternative_titles ||= parser.parse_alternative_titles
    end

    def release_dates
      @release_dates ||= parser.parse_release_dates
    end

    def release_date
      @release_date ||= release_dates.first[:date] rescue nil
    end

    def critic_reviews
      @critic_reviews ||= parser.parse_critic_reviews
    end

    private

    def parser
      @parser ||= Spotlite::MovieParser.new(imdb_id)
    end
  end
end
