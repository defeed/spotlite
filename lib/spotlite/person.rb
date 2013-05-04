module Spotlite
  
  # Represent a person on IMDb.com
  class Person
    attr_accessor :imdb_id, :name
    
    # Initialize a new person object by its IMDb ID as a string
    #
    #   person = Spotlite::Person.new("0005132")
    #
    # Spotlite::Person class objects are lazy loading. No HTTP request
    # will be performed upon object initialization. HTTP request will
    # be performed once when you use a method that needs remote data
    def initialize(imdb_id, name = nil)
      @imdb_id = imdb_id
      @name    = name
      @url     = "http://www.imdb.com/name/nm#{imdb_id}"
    end
    
    # Returns name as a string
    def name
      @name ||= details.at("h1.header[itemprop='name']").text.strip.clean_name
    end
    
    # Returns name at birth as a string
    def birth_name
      details.at("#overview-top .txt-block a[href='bio']").text.strip rescue nil
    end
    
    # Returns birth date as a date
    def birth_date
      details.at("time[itemprop='birthDate']")["datetime"].parse_date rescue nil
    end
    
    # Returns death date as a date
    def death_date
      details.at("time[itemprop='deathDate']")["datetime"].parse_date rescue nil
    end
    
    # Returns primary photo URL as a string
    def photo_url
      src = details.at("#img_primary img")["src"] rescue nil
      
      if src =~ /^(http:.+@@)/ || src =~ /^(http:.+?)\.[^\/]+$/
        $1 + ".jpg"
      end
    end
    
    private
    
    def details # :nodoc:
      @details ||= open_page
    end
    
    def open_page(page = nil) # :nodoc:
      Nokogiri::HTML(open("http://www.imdb.com/name/nm#{@imdb_id}/#{page}",
                          "Accept-Language" => "en-us"))
    end
  end
end
