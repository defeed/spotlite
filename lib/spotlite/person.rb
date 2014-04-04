module Spotlite
  
  # Represents a person on IMDb.com
  class Person
    attr_accessor :imdb_id, :name, :url, :credits_category, :credits_text
    
    # Initialize a new person object by its IMDb ID as a string
    #
    #   person = Spotlite::Person.new("0005132")
    #
    # Spotlite::Person class objects are lazy loading. No HTTP request
    # will be performed upon object initialization. HTTP request will
    # be performed once when you use a method that needs remote data
    def initialize(imdb_id, name = nil, credits_category = nil, credits_text = nil)
      @imdb_id = "%07d" % imdb_id.to_i
      @name = name
      @url = "http://www.imdb.com/name/nm#{@imdb_id}/"
      @credits_category = credits_category
      @credits_text = credits_text
    end
    
    # Returns name as a string
    def name
      @name ||= details.at("h1.header span[itemprop='name']").text.strip.clean_name
    end
    
    # Returns name at birth as a string
    def birth_name
      details.at("#name-born-info a[href^='/name/']").text.strip rescue nil
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
      Nokogiri::HTML open("#{@url}#{page}", "Accept-Language" => "en-us")
    end
  end
end
