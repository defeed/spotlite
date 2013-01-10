module Spotlite

  class Movie
    attr_accessor :imdb_id, :title, :url
    
    def initialize(imdb_id, title = nil, url = nil)
      @imdb_id = imdb_id
      @title   = title
      @url     = "http://www.imdb.com/title/tt#{imdb_id}/"
    end
    
    def title
      @title ||= combined.css("#tn15title h1").children.first.text.strip
    end
    
    def year
      combined.search("a[href^='/year/']").text.to_i rescue nil
    end
    
    def rating
      combined.css("div.starbar-meta b").children.first.text.split("/").first.to_f rescue nil
    end
    
    def votes
      combined.css("div.starbar-meta a.tn15more").text.gsub(/[^\d+]/, "").to_i rescue nil
    end
    
    def genres
      combined.css("div.info-content").search("a[href^='/Sections/Genres/']").map { |genre| genre.text } rescue []
    end
    
    private
    
    def combined
      @combined ||= Nokogiri::HTML(open_page(@imdb_id, "combined"))
    end
    
    def release_info
      @release_info ||= Nokogiri::HTML(open_page(@imdb_id, "releaseinfo"))
    end
    
    def full_credits
      @full_credits ||= Nokogiri::HTML(open_page(@imdb_id, "fullcredits"))
    end
    
    def plot_keywords
      @plot_keywords ||= Nokogiri::HTML(open_page(@imdb_id, "keywords"))
    end
    
    def open_page(imdb_id, page)
      open("http://akas.imdb.com/title/tt#{imdb_id}/#{page}")
    end
  end

end
