module Spotlite
  
  # Represents a person on IMDb.com
  class Person
    attr_accessor :imdb_id, :name, :url, :credits_category, :credits_text
    
    # Initialize a new person object by its IMDb ID as a string
    #
    #   person = Spotlite::Person.new('0005132')
    #
    # Spotlite::Person class objects are lazy loading. No HTTP request
    # will be performed upon object initialization. HTTP request will
    # be performed once when you use a method that needs remote data
    def initialize(imdb_id, name = nil, credits_category = nil, credits_text = nil)
      @imdb_id = "%07d" % imdb_id.to_i
      @name = name
      @url = "http://www.imdb.com/name/nm#{@imdb_id}/"
      @credits_category = credits_category if credits_category
      @credits_text = credits_text if credits_text
    end
    
    # Returns a list of people as an array of +Spotlite::Person+ objects
    # Takes single parameter and searches for people by names and nicknames
    def self.find(query)
      results = Spotlite::Client.get 'http://www.imdb.com/find', query: {q: query, s: 'nm'}
      results.css('.result_text').map do |result|
        imdb_id = result.at('a')['href'].parse_imdb_id
        name    = result.at('a').text.strip
      
        [imdb_id, name]
      end.map do |values|
        self.new(*values)
      end
    end
    
    # Returns a list of people as an array of +Spotlite::Person+ objects
    # Takes optional parameters as a hash
    # See https://github.com/defeed/spotlite/wiki/Advanced-person-search for details
    def self.search(params = {})
      defaults = {
        view: 'simple',
        count: 250,
        start: 1,
        gender: 'male,female',
        sort: 'starmeter,asc'
      }
      params = defaults.merge(params)
      results = Spotlite::Client.get 'http://www.imdb.com/search/name', query: params
      results.css('td.name').map do |result|
        imdb_id = result.at('a')['href'].parse_imdb_id
        name    = result.at('a').text.strip
      
        [imdb_id, name]
      end.map do |values|
        self.new(*values)
      end
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
      details.at("time[itemprop='birthDate']")['datetime'].parse_date rescue nil
    end
    
    # Returns death date as a date
    def death_date
      details.at("time[itemprop='deathDate']")['datetime'].parse_date rescue nil
    end
    
    # Returns primary photo URL as a string
    def photo_url
      src = details.at('#img_primary img')['src'] rescue nil
      
      if src =~ /^(http:.+@@)/ || src =~ /^(http:.+?)\.[^\/]+$/
        $1 + '.jpg'
      end
    end
    
    # Returns either a hash or an array of movies comprising person's filmography
    # Returns array if `flatten = true`, returns hash if `flatten = false`.
    # Hash keys are symbols of either 4 basic jobs (director, actor/actress, writer, producer)
    #   or person's all available jobs
    # `extended = true` will return all available jobs, `extended = false` will return
    #   movies under those 4 basic jobs
    def filmography(extended = false, flatten = true)
      hash = {}
      jobs = extended ? available_jobs : %w(director actor actress writer producer)
      
      jobs.map do |job|
        hash[job.to_sym] = parse_movies(job) if available_jobs.include?(job)
      end
      
      flatten ? hash.values.flatten : hash
    end
    
    private
    
    # Returns a list of all jobs a person took part in movies as an array of strings
    # Used to retrieve person's filmography
    def available_jobs
      details.at('#filmography').css("div[data-category$='Movie']").map{ |job| job['data-category'].gsub('Movie', '') }
    end
    
    # Returns a list of movies that fall under a certain job type, as an array of +Spotlite::Movie+
    def parse_movies(job)
      details.css("div[id^='#{job}Movie-tt']").map do |row|
        imdb_id = row.at("a[href^='/title/tt']")['href'].parse_imdb_id
        title   = row.at('a').text.strip
        year    = row.at('.year_column').text.parse_year
      
        [imdb_id, title, year]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
    
    def details # :nodoc:
      @details ||= open_page(nil, {nmdp: 1})
    end
    
    def open_page(page = nil, query = {}) # :nodoc:
      Spotlite::Client.get("#{@url}#{page}", query: query)
    end
  end
end
