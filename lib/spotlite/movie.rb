module Spotlite
  # Represents a movie on IMDb.com
  class Movie
    attr_accessor :imdb_id, :url, :response

    # Initialize a new movie object by its IMDb ID as a string
    #
    #   movie = Spotlite::Movie.new('0133093')
    #
    # Spotlite::Movie class objects are lazy loading. No HTTP request
    # will be performed upon object initialization. HTTP request will
    # be performed once when you use a method that needs remote data
    # Currently, all data is spread across 6 pages: main movie page,
    # /releaseinfo, /fullcredits, /keywords, /trivia, and /criticreviews
    def initialize(imdb_id, title = nil, year = nil)
      @imdb_id = "%07d" % imdb_id.to_i
      @title   = title
      @year    = year
      @url     = "http://www.imdb.com/title/tt#{@imdb_id}/"
    end

    # Returns a list of movies as an array of +Spotlite::Movie+ objects
    # Takes single parameter and searches for movies by title and alternative titles
    def self.find(query)
      results = Spotlite::Client.get(
        'http://www.imdb.com/find', query: { q: query, s: 'tt', ttype: 'ft' }
      )
      results.css('.result_text').map do |result|
        imdb_id = result.at('a')['href'].parse_imdb_id
        title   = result.at('a').text.strip
        year    = result.children.take(3).last.text.parse_year

        [imdb_id, title, year]
      end.map do |values|
        self.new(*values)
      end
    end

    # Returns a list of movies as an array of +Spotlite::Movie+ objects
    # Takes optional parameters as a hash
    # See https://github.com/defeed/spotlite/wiki/Advanced-movie-search for details
    def self.search(params = {})
      defaults = {
        title_type: 'feature',
        view: 'simple',
        count: 250,
        start: 1,
        sort: 'moviemeter,asc'
      }
      params = defaults.merge(params)
      results = Spotlite::Client.get(
        'http://www.imdb.com/search/title', query: params
      )
      results.css('td.title').map do |result|
        imdb_id = result.at('a')['href'].parse_imdb_id
        title   = result.at('a').text.strip
        year    = result.at('.year_type').text.parse_year

        [imdb_id, title, year]
      end.map do |values|
        self.new(*values)
      end
    end

    # Returns title as a string
    def title
      # strip some non-breaking space at the end
      @title ||= details.at("h1[itemprop='name']").children.first.text.strip.gsub(' ', '') rescue nil
    end

    # Returns original non-english title as a string
    def original_title
      details.at("h1.header span.title-extra[itemprop='name']").children.first.text.gsub('"', '').strip rescue nil
    end

    # Returns year of original release as an integer
    def year
      @year ||= details.at("h1[itemprop='name'] span#titleYear a").text.parse_year rescue nil
    end

    # Returns IMDb rating as a float
    def rating
      details.at("div.imdbRating span[itemprop='ratingValue']").text.to_f rescue nil
    end

    # Returns Metascore rating as an integer
    def metascore
      details.at("div.titleReviewBar a[href^=criticreviews] span").text.to_i rescue nil
    end

    # Returns number of votes as an integer
    def votes
      details.at("div.imdbRating span[itemprop='ratingCount']").text.gsub(/[^\d+]/, '').to_i rescue nil
    end

    # Returns short description as a string
    def description
      desc = details.at("div.summary_text[itemprop='description']").text.strip.clean_description rescue nil
      (desc.nil? || desc.empty?) ? nil : desc
    end

    # Returns storyline as a string. Often is the same as description
    def storyline
      details.at("#titleStoryLine div[itemprop='description'] p").text.strip.clean_description rescue nil
    end

    # Returns a list of plot summaries as an array of strings
    def summaries
      plot_summaries.css("p.plotSummary").map { |summary| summary.text.strip }
    end

    # Returns content rating as a string
    def content_rating
      details.at(".infobar meta[itemprop='contentRating']")['content'] rescue nil
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
        array << {:code => node['href'].clean_href, :name => node.text.strip}
      end

      array
    end

    # Returns a list of languages as an array of hashes
    # with keys: +code+ (string) and +name+ (string)
    def languages
      array = []
      details.css("div.txt-block a[href^='/language/']").each do |node|
        array << {:code => node['href'].clean_href, :name => node.text.strip}
      end

      array
    end

    # Returns runtime (length) in minutes as an integer
    def runtime
      details.at("time[itemprop='duration']").text.gsub(',', '').to_i rescue nil
    end

    # Returns primary poster URL as a string
    def poster_url
      src = details.at('#img_primary img')['src'] rescue nil

      if src =~ /^(http:.+@@)/ || src =~ /^(http:.+?)\.[^\/]+$/
        $1 + '.jpg'
      end
    end

    # Returns an array of recommended movies as an array of initialized objects of +Movie+ class
    def recommended_movies
      details.css('.rec-title').reject do |node|
        # reject movies that don't have a release year yet
        node.at('span').nil?
      end.reject do |node|
        # reject everything other than featured film
        /\d{4}-\d{4}/.match(node.at('span').text) ||
          /Series|Episode|Video|Documentary|Movie|Special|Short|Game|Unknown/.match(node.at('span').text)
      end.map do |node|
        imdb_id = node.at("a[href^='/title/tt']")['href'].parse_imdb_id
        title   = node.at('a').text.strip
        year    = node.at('span').text.parse_year

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

    # Returns a list of movie alternative titles as an array of hashes
    # with keys +title+ (string) and +comment+ (string)
    def alternative_titles
      array = []
      release_info.css('#akas').css('tr').map do |row|
        cells = row.css('td')
        array << { :title => cells.last.text.strip, :comment => cells.first.text.strip }
      end

      array
    end

    # Returns a list of directors as an array of +Spotlite::Person+ objects
    def directors
      parse_crew('Directed by')
    end

    # Returns a list of writers as an array of +Spotlite::Person+ objects
    def writers
      parse_crew('Writing Credits')
    end

    # Returns a list of producers as an array of +Spotlite::Person+ objects
    def producers
      parse_crew('Produced by')
    end

    # Returns a list of starred actors as an array of +Spotlite::Person+ objects
    def stars
      details.css("td#overview-top div[itemprop='actors'] a[href^='/name/nm']").map do |node|
        imdb_id = node['href'].parse_imdb_id
        name = node.text.strip

        [imdb_id, name]
      end.map do |values|
        Spotlite::Person.new(*values)
      end
    end

    # Returns a list of actors as an array +Spotlite::Person+ objects
    def cast
      full_credits.css('table.cast_list tr').reject do |row|
        # Skip 'Rest of cast' row
        row.children.size == 1
      end.map do |row|
        imdb_id = row.at('td:nth-child(2) a')['href'].parse_imdb_id
        name = row.at('td:nth-child(2) a').text.strip_whitespace
        credits_text = row.last_element_child.text.strip_whitespace

        [imdb_id, name, 'Cast', credits_text]
      end.map do |values|
        Spotlite::Person.new(*values)
      end
    end

    # Returns a list of crew members of a certain category as an array +Spotlite::Person+ objects
    def parse_crew(category)
      table = full_credits.search("[text()^='#{category}']").first.next_element rescue nil
      if table && table.name == 'table'
        table.css('tr').reject do |row|
          # Skip empty table rows with one non-braking space
          row.text.strip.size == 1
        end.map do |row|
          imdb_id = row.first_element_child.at('a')['href'].parse_imdb_id
          name = row.first_element_child.at('a').text.strip_whitespace
          credits_text = row.last_element_child.text.strip_whitespace.clean_credits_text

          [imdb_id, name, category, credits_text]
        end.map do |values|
          Spotlite::Person.new(*values)
        end
      else
        []
      end
    end

    # Combines all crew categories and returns an array of +Spotlite::Person+ objects
    def crew
      crew_categories.map{ |category| parse_crew(category) }.flatten
    end

    # Returns combined `cast` and `crew` as an array of +Spotlite::Person+ objects
    def credits
      cast + crew
    end

    # Returns available crew categories, e.g. "Art Department", "Writing Credits", or "Stunts", as an array of strings
    def crew_categories
      array = []
      full_credits.css('h4.dataHeaderWithBorder').reject{ |h| h['id'] == 'cast' }.map do |node|
        array << (node.children.size > 1 ? node.children.first.text.strip_whitespace : node.children.text.strip_whitespace)
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
      table = release_info.at('#release_dates')
      table.css('tr').map do |row|
        cells = row.css('td')
        code = cells.first.at('a')['href'].clean_href.split('=').last.downcase rescue nil
        region = cells.first.at('a').text rescue nil
        date = cells.at('.release_date').text.strip.parse_date
        comment = cells.last.text.strip.clean_release_comment
        comment = nil if comment.empty?

        array << { :code => code, :region => region, :date => date, :comment => comment }
      end unless table.nil?

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

        array << { :source => source, :author => author, :excerpt => excerpt, :score => score }
      end

      array
    end

    # Returns URLs of movie still frames as an array of strings
    def images
      array = []
      still_frames.css('#media_index_thumbnail_grid img').map do |image|
        src = image['src'] rescue nil

        if src =~ /^(http:.+@@)/ || src =~ /^(http:.+?)\.[^\/]+$/
          array << $1 + '.jpg'
        end
      end

      array
    end

    # Returns technical information like film length, aspect ratio, cameras, etc. as a hash of arrays of strings
    def technical
      hash = {}
      table = technical_info.at_css('#technical_content table') rescue nil

      table.css('tr').map do |row|
        hash[row.css('td').first.text.strip] = row.css('td').last.children.
          map(&:text).
          map(&:strip_whitespace).
          reject(&:empty?).
          reject{|i| i == '|'}.
          slice_before{|i| /^[^\(]/.match i}.
          map{|i| i.join(' ')}
      end unless table.nil?

      hash
    end

    private

    def details # :nodoc:
      @details ||= open_page
    end

    def release_info # :nodoc:
      @release_info ||= open_page('releaseinfo')
    end

    def full_credits # :nodoc:
      @full_credits ||= open_page('fullcredits')
    end

    def plot_keywords # :nodoc:
      @plot_keywords ||= open_page('keywords')
    end

    def movie_trivia # :nodoc:
      @movie_trivia ||= open_page('trivia')
    end

    def reviews
      @reviews ||= open_page('criticreviews')
    end

    def still_frames # :nodoc:
      @still_frames ||= open_page('mediaindex', {refine: 'still_frame'})
    end

    def technical_info # :nodoc:
      @technical_info ||= open_page('technical')
    end

    def plot_summaries # :nodoc:
      @plot_summaries ||= open_page('plotsummary')
    end

    def open_page(page = nil, query = {}) # :nodoc:
      response = Spotlite::Client.get "#{@url}#{page}", query: query
      @response = { code: response.code, message: response.message } and response
    end
  end

end
