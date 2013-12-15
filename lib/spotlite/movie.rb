module Spotlite

  # Represents a movie on IMDb.com
  class Movie
    attr_accessor :imdb_id, :title, :year
    
    # Initialize a new movie object by its IMDb ID as a string
    #
    #   movie = Spotlite::Movie.new("0133093")
    #
    # Spotlite::Movie class objects are lazy loading. No HTTP request
    # will be performed upon object initialization. HTTP request will
    # be performed once when you use a method that needs remote data
    # Currently, all data is spread across 6 pages: main movie page,
    # /releaseinfo, /fullcredits, /keywords, /trivia, and /criticreviews
    def initialize(imdb_id, title = nil, year = nil)
      @imdb_id = imdb_id
      @title   = title
      @year    = year
      @url     = "http://www.imdb.com/title/tt#{imdb_id}/"
    end
    
    # Returns title as a string
    def title
      @title ||= details.at("h1.header span[itemprop='name']").text.strip
    end
    
    # Returns original non-english title as a string
    def original_title
      details.at("h1.header span.title-extra[itemprop='name']").children.first.text.gsub('"', "").strip rescue nil
    end
    
    # Returns year of original release as an integer
    def year
      @year ||= details.at("h1.header a[href^='/year/']").text.parse_year rescue nil
    end
    
    # Returns IMDb rating as a float
    def rating
      details.at("div.star-box-details span[itemprop='ratingValue']").text.to_f rescue nil
    end
    
    # Returns Metascore rating as an integer
    def metascore
      details.at("div.star-box-details a[href^=criticreviews]").text.strip.split("/").first.to_i rescue nil
    end
    
    # Returns number of votes as an integer
    def votes
      details.at("div.star-box-details span[itemprop='ratingCount']").text.gsub(/[^\d+]/, "").to_i rescue nil
    end
    
    # Returns short description as a string
    def description
      details.at("p[itemprop='description']").text.strip.clean_description rescue nil
    end
    
    # Returns storyline as a string. Often is the same as description
    def storyline
      details.at("#titleStoryLine div[itemprop='description'] p").text.strip.clean_description rescue nil
    end
    
    # Returns content rating as a string
    def content_rating
      details.at(".infobar span[itemprop='contentRating']")['title'] rescue nil
    end
    
    # Returns a list of genres as an array of strings
    def genres
      details.css("div.infobar a[href^='/genre/']").map { |genre| genre.text } rescue []
    end
    
    # Returns a list of countries as an array of hashes
    # with keys: +code+ (string) and +name+ (string)
    def countries
      array = []
      details.css("div.txt-block a[href^='/country/']").each do |node|
        array << {:code => node["href"].clean_href, :name => node.text.strip}
      end
      
      array
    end
    
    # Returns a list of languages as an array of hashes
    # with keys: +code+ (string) and +name+ (string)
    def languages
      array = []
      details.css("div.txt-block a[href^='/language/']").each do |node|
        array << {:code => node["href"].clean_href, :name => node.text.strip}
      end
      
      array
    end
    
    # Returns runtime (length) in minutes as an integer
    def runtime
      details.at("time[itemprop='duration']").text.to_i rescue nil ||
      details.at("#overview-top .infobar").text.strip[/\d{2,3} min/].to_i rescue nil
    end
    
    # Returns primary poster URL as a string
    def poster_url
      src = details.at("#img_primary img")["src"] rescue nil
      
      if src =~ /^(http:.+@@)/ || src =~ /^(http:.+?)\.[^\/]+$/
        $1 + ".jpg"
      end
    end
    
    # Returns an array of recommended movies as an array of initialized objects of +Movie+ class
    def recommended_movies
      details.css(".rec-title").map do |node|
        imdb_id = node.at("a[href^='/title/tt']")['href'].parse_imdb_id
        title   = node.at("a").text.strip
        year    = node.at("span").text.parse_year
      
        [imdb_id, title, year]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
    
    # Returns a list of keywords as an array of strings
    def keywords
      plot_keywords.css("a[href^='/keyword/']").map { |keyword| keyword.text.strip } rescue []
    end
    
    # Returns a list of trivia facts as an array of strings
    def trivia
      movie_trivia.css("div.sodatext").map { |node| node.text.strip } rescue []
    end
    
    # Returns a list of directors as an array of hashes
    # with keys: +imdb_id+ (string) and +name+ (string)
    def directors
      parse_staff("Directed by")
    end
    
    # Returns a list of writers as an array of hashes
    # with keys: +imdb_id+ (string) and +name+ (string)
    def writers
      parse_staff("Writing Credits")
    end
    
    # Returns a list of producers as an array of hashes
    # with keys: +imdb_id+ (string) and +name+ (string)
    def producers
      parse_staff("Produced by")
    end
    
    # Returns a list of actors as an array of hashes
    # with keys: +imdb_id+ (string), +name+ (string), and +character+ (string)
    def cast
      table = full_credits.css("table.cast_list")
      names = table.css("td[itemprop='actor']").map { |node| node.text.strip } rescue []
      links = table.css("td[itemprop='actor'] a").map { |node| node["href"].clean_href } rescue []
      imdb_ids = links.map { |link| link.parse_imdb_id } unless links.empty?
      characters = table.css("td.character").map { |node| node.text.clean_character }
      
      array = []
      0.upto(names.size - 1) do |i|
        array << {:imdb_id => imdb_ids[i], :name => names[i], :character => characters[i]}
      end
      
      array
    end
    
    # Returns a list of starred actors as an array of hashes
    # with keys: +imdb_id+ (string) and +name+ (string)
    def stars
      array = []
      details.css("td#overview-top div[itemprop='actors'] a[href^='/name/nm']").map do |node|
        name = node.text.strip
        imdb_id = node["href"].parse_imdb_id
        
        array << {:imdb_id => imdb_id, :name => name}
      end
      
      array
    end
    
    # Returns a list of regions and corresponding release dates
    # as an array of hashes with keys:
    # region +code+ (string), +region+ name (string), +date+ (date), and +comment+ (string)
    # If day is unknown, 1st day of month is assigned
    # If day and month are unknown, 1st of January is assigned
    def release_dates
      array = []
      release_info.at("#release_dates").css("tr").map do |row|
        code = row.at("a")["href"].clean_href.split("=").last.downcase rescue nil
        region = row.at("a").text rescue nil
        date = row.at("td.release_date").text.strip.parse_date rescue nil
        comment = row.css("td").last.text.strip.clean_release_comment rescue nil
        comment = nil if comment.empty?
        
        array << {:code => code, :region => region, :date => date, :comment => comment}
      end
      
      array
    end
    
    # Returns original release date as a date
    def release_date
      release_dates.first[:date] rescue nil
    end
    
    # Returns a list of critic reviews as an array of hashes
    # with keys: +source+ (string), +author+ (string), +excerpt+ (string), and +score+ (integer)
    def critic_reviews
      array = []
      reviews.css("tr[itemprop='reviews']").map do |review|
        source = review.at("b[itemprop='publisher'] span[itemprop='name']").text
        author = review.at("span[itemprop='author'] span[itemprop='name']").text
        excerpt = review.at("div[itemprop='reviewbody']").text.strip
        score = review.at("span[itemprop='ratingValue']").text.to_i
        
        array << {:source => source, :author => author, :excerpt => excerpt, :score => score}
      end
      
      array
    end
    
    # Returns URLs of movie still frames as an array of strings
    def images
      array = []
      still_frames.css("#media_index_thumbnail_grid img").map do |image|
        src = image["src"] rescue nil
      
        if src =~ /^(http:.+@@)/ || src =~ /^(http:.+?)\.[^\/]+$/
          array << $1 + ".jpg"
        end
      end
      
      array
    end
    
    private
    
    def details # :nodoc:
      @details ||= open_page
    end
    
    def release_info # :nodoc:
      @release_info ||= open_page("releaseinfo")
    end
    
    def full_credits # :nodoc:
      @full_credits ||= open_page("fullcredits")
    end
    
    def plot_keywords # :nodoc:
      @plot_keywords ||= open_page("keywords")
    end
    
    def movie_trivia # :nodoc:
      @movie_trivia ||= open_page("trivia")
    end
    
    def reviews
      @reviews ||= open_page("criticreviews")
    end
    
    def still_frames
      @still_frames ||= open_page("mediaindex?refine=still_frame")
    end
    
    def open_page(page = nil) # :nodoc:
      Nokogiri::HTML(open("http://www.imdb.com/title/tt#{@imdb_id}/#{page}",
                          "Accept-Language" => "en-us"))
    end
    
    def parse_staff(staff) # :nodoc:
      array = []
      # table = full_credits.at("a[name='#{staff}']").parent.parent.parent.parent rescue nil
      table = full_credits.search("[text()*='#{staff}']").first.next_element rescue nil
      if table && table.name == "table"
        table.css("a[href^='/name/nm']").map do |node|
          imdb_id = node["href"].parse_imdb_id
          name = node.text.strip
        
          array << {:imdb_id => imdb_id, :name => name}
        end
      end
      
      array.uniq
    end
  end

end
