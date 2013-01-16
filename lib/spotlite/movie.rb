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
    
    def original_title
      details.at("h1[itemprop='name'] span.title-extra").children.first.text.strip rescue nil
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
      block = details.at("#maindetails_center_bottom .txt-block a[href^='/country/']").parent
      names = block.css("a[href^='/country/']").map { |node| node.text } rescue []
      links = block.css("a[href^='/country/']").map { |node| node["href"] } rescue []
      codes = links.map { |link| link.split("/").last } unless links.empty?
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:code => codes[i], :name => names[i]}
      end
      
      array
    end
    
    def languages
      block = details.at("#maindetails_center_bottom .txt-block a[href^='/language/']").parent
      names = block.css("a[href^='/language/']").map { |node| node.text } rescue []
      links = block.css("a[href^='/language/']").map { |node| node["href"] } rescue []
      codes = links.map { |link| link.split("/").last } unless links.empty?
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:code => codes[i], :name => names[i]}
      end
      
      array
    end
    
    def runtime
      details.at("time[itemprop='duration']").text.to_i rescue nil ||
      details.at("#overview-top .infobar").text.strip[/\d{2,3} min/].to_i rescue nil
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
    
    def trivia
      movie_trivia.css("div.sodatext").map { |node| node.text.strip } rescue []
    end
    
    def directors
      names = full_credits.at("a[name='directors']").parent.parent.parent.parent.css("a[href^='/name/nm']").map { |node| node.text } rescue []
      links = full_credits.at("a[name='directors']").parent.parent.parent.parent.css("a[href^='/name/nm']").map { |node| node["href"] } rescue []
      imdb_ids = links.map { |link| link[/\d+/] } unless links.empty?
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:imdb_id => imdb_ids[i], :name => names[i]}
      end
      
      array
    end
    
    def writers
      names = full_credits.at("a[name='writers']").parent.parent.parent.parent.css("a[href^='/name/nm']").map { |node| node.text } rescue []
      links = full_credits.at("a[name='writers']").parent.parent.parent.parent.css("a[href^='/name/nm']").map { |node| node["href"] } rescue []
      imdb_ids = links.map { |link| link[/\d+/] } unless links.empty?
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:imdb_id => imdb_ids[i], :name => names[i]}
      end
      
      array
    end
    
    def producers
      names = full_credits.at("a[name='producers']").parent.parent.parent.parent.css("a[href^='/name/nm']").map { |node| node.text } rescue []
      links = full_credits.at("a[name='producers']").parent.parent.parent.parent.css("a[href^='/name/nm']").map { |node| node["href"] } rescue []
      imdb_ids = links.map { |link| link[/\d+/] } unless links.empty?
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:imdb_id => imdb_ids[i], :name => names[i]}
      end
      
      array
    end
    
    def cast
      table = full_credits.css("table.cast")
      names = table.css("td.nm").map { |node| node.text } rescue []
      links = table.css("td.nm a").map { |node| node["href"] } rescue []
      imdb_ids = links.map { |link| link[/\d+/] } unless links.empty?
      characters = table.css("td.char").map { |node| node.text }
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:imdb_id => imdb_ids[i], :name => names[i], :character => characters[i]}
      end
      
      array
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
    
    def movie_trivia
      @movie_trivia ||= Nokogiri::HTML(open_page(@imdb_id, "trivia"))
    end
    
    def open_page(imdb_id, page = nil)
      open("http://www.imdb.com/title/tt#{imdb_id}/#{page}")
    end
  end

end
