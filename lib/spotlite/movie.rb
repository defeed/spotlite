module Spotlite

  class Movie
    attr_accessor :imdb_id, :title, :url
    
    def initialize(imdb_id, title = nil, url = nil)
      @imdb_id = imdb_id
      @title   = title
      @url     = "http://www.imdb.com/title/tt#{imdb_id}/"
    end
    
    def title
      @title ||= details.at("h1[itemprop='name']").children.first.text.strip
    end
    
    def year
      details.at("h1[itemprop='name'] a[href^='/year/']").text.to_i rescue nil
    end
    
    def rating
      details.at("div.star-box span[itemprop='ratingValue']").text.to_f rescue nil
    end
    
    def votes
      details.at("div.star-box span[itemprop='ratingCount']").text.gsub(/[^\d+]/, "").to_i rescue nil
    end
    
    def description
      details.at("p[itemprop='description']").children.first.text.strip rescue nil
    end
    
    def genres
      details.css("div.infobar a[href^='/genre/']").map { |genre| genre.text } rescue []
    end
    
    def countries
      details.css("#maindetails_center_bottom .txt-block a[href^='/country/']").map { |country| country.text } rescue []
    end
    
    def languages
      details.css("#maindetails_center_bottom .txt-block a[href^='/language/']").map { |language| language.text } rescue []
    end
    
    def runtime
      details.at("time[itemprop='duration']").text.to_i rescue nil
    end
    
    def poster_url
      src = details.at("#img_primary img")["src"] rescue nil
      
      case src
      when /^(http:.+@@)/
        $1 + '.jpg'
      when /^(http:.+?)\.[^\/]+$/
        $1 + '.jpg'
      end
    end
    
    def keywords
      plot_keywords.css("li b.keyword").map { |keyword| keyword.text.strip } rescue []
    end
    
    private
    
    def details
      @details ||= Nokogiri::HTML(open_page(@imdb_id))
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
    
    def open_page(imdb_id, page = nil)
      open("http://www.imdb.com/title/tt#{imdb_id}/#{page}")
    end
  end

end
