require_relative 'string_extensions'

module Spotlite
  class MovieParser
    def initialize(imdb_id)
      @imdb_id = imdb_id
      @url     = "http://www.imdb.com/title/tt#{@imdb_id}/"
    end

    def parse_title
      details.at("h1[itemprop='name']").children.first.text.strip_whitespace rescue nil
    end

    def parse_original_title
      details.at("div.originalTitle").children.first.text.gsub('"', '').strip rescue nil
    end

    def parse_year
      details.at("h1[itemprop='name'] span#titleYear a").text.parse_year rescue nil
    end

    def parse_rating
      details.at("div.imdbRating span[itemprop='ratingValue']").text.to_f rescue nil
    end

    def parse_votes
      details.at("div.imdbRating span[itemprop='ratingCount']").text.gsub(/[^\d+]/, '').to_i rescue nil
    end

    def parse_metascore
      details.at("div.titleReviewBar a[href^=criticreviews] span").text.to_i rescue nil
    end

    def parse_description
      desc = details.at("div.summary_text").text.strip.clean_description rescue nil
      (desc.nil? || desc.empty?) ? nil : desc
    end

    def parse_storyline
      details.at("#titleStoryLine span[itemprop='description']").text.strip rescue nil
    end

    def parse_content_rating
      details.at("div.subtext meta[itemprop='contentRating']")['content'] rescue nil
    end

    def parse_genres
      details.css("div.subtext a[href^='/genre/']").map(&:text) rescue []
    end

    def parse_countries
      array = []
      details.css("div.txt-block a[href*='country_of_origin=']").each do |node|
        array << { code: node['href'].parse_country_code, name: node.text.strip}
      end

      array
    end

    def parse_languages
      array = []
      details.css("div.txt-block a[href*='primary_language=']").each do |node|
        array << { code: node['href'].parse_language_code, name: node.text.strip}
      end

      array
    end

    def parse_runtime
      details.at("div.subtext time[itemprop='duration']")['datetime'].gsub(/[^\d+]/, '').to_i rescue nil
    end

    def parse_stars
      array = []
      details.css("div.plot_summary_wrapper span[itemprop='actors'] a[href^='/name/nm']").map do |node|
        imdb_id = node['href'].parse_imdb_id
        name = node.text.strip

        array << { imdb_id: imdb_id, name: name }
      end

      array
    end

    def parse_recommended_movies
      array = []
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

        array << { imdb_id: imdb_id, title: title, year: year }
      end

      array
    end

    def parse_poster_url
      src = details.at('div.poster img')['src'] rescue nil

      if src =~ /^(https:.+@@)/ || src =~ /^(https:.+?)\.[^\/]+$/
        $1 + '.jpg'
      end
    end

    def parse_summaries
      plot_summaries.css("[id^='summary-'] p").map { |summary| summary.text.strip }
    end

    def parse_keywords
      plot_keywords.css("a[href^='/keyword/']").map { |keyword| keyword.text.strip }
    end

    def parse_trivia
      movie_trivia.css("div.sodatext").map { |node| node.text.strip } rescue []
    end

    def parse_taglines
      movie_taglines.css("#taglines_content > .soda").map { |node| node.text.strip }
    end

    private

    def details
      @details ||= open_page
    end

    def plot_summaries
      @plot_summaries ||= open_page("plotsummary")
    end

    def plot_keywords
      @plot_keywords ||= open_page("keywords")
    end

    def movie_trivia
      @movie_trivia ||= open_page("trivia")
    end

    def movie_taglines
      @movie_taglines ||= open_page("taglines")
    end

    def open_page(page = nil, query = {})
      Spotlite::Client.get("#{@url}#{page}", query: query)
    end
  end
end
