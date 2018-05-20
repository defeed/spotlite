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

      extract_image_url(src)
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

    def parse_alternative_titles
      array = []
      release_info.css('#akas').css('tr').map do |row|
        cells = row.css('td')
        array << { title: cells.last.text.strip, comment: cells.first.text.strip }
      end

      array
    end

    def parse_release_dates
      array = []
      table = release_info.at('#release_dates')
      table.css('tr').map do |row|
        cells = row.css('td')
        code = cells.first.at('a')['href'].clean_href.split('=').last.downcase rescue nil
        region = cells.first.at('a').text rescue nil
        date = cells.at('.release_date').text.strip.parse_date.to_s
        comment = cells.last.text.strip.clean_release_comment
        comment = nil if comment.empty?

        array << { code: code, region: region, date: date, comment: comment }
      end unless table.nil?

      array
    end

    def parse_critic_reviews
      array = []
      critic_reviews.css("tr[itemprop='reviews']").map do |review|
        source = review.at("b[itemprop='publisher'] span[itemprop='name']").text
        author = review.at("span[itemprop='author'] span[itemprop='name']").text
        url = review.at("a[itemprop='url']")['href'] rescue nil
        excerpt = review.at("div[itemprop='reviewbody']").text.strip
        score = review.at("span[itemprop='ratingValue']").text.to_i

        array << {
          source: source.empty? ? nil : source,
          author: author.empty? ? nil : author,
          url: url,
          excerpt: excerpt,
          score: score
        }
      end

      array
    end

    def parse_images
      array = []
      still_frames.css('#media_index_thumbnail_grid img').map do |image|
        src = image['src'] rescue nil
        array << extract_image_url(src)
      end

      array
    end

    def parse_cast
      array = []
      full_credits.css('table.cast_list tr').reject do |row|
        # Skip 'Rest of cast' row
        row.children.size == 1
      end.map do |row|
        imdb_id = row.at('td:nth-child(2) a')['href'].parse_imdb_id
        name = row.at('td:nth-child(2) a').text.strip_whitespace
        credits_text = row.last_element_child.text.strip_whitespace

        array << {
          imdb_id: imdb_id,
          name: name,
          credit_category: "Cast",
          credits_text: credits_text
        }
      end

      array
    end


    def parse_crew
      crew_categories.map{ |category| parse_crew_for(category) }.flatten
    end

    def parse_credits
      parse_cast + parse_crew
    end

    def parse_directors
      parse_crew_for('Directed by')
    end

    def parse_writers
      parse_crew_for('Writing Credits')
    end

    def parse_producers
      parse_crew_for('Produced by')
    end

    private

    def extract_image_url(src = nil)
      if src =~ /^(https:.+@@)/ || src =~ /^(https:.+?)\.[^\/]+$/
        $1 + ".jpg"
      end
    end

    def crew_categories
      array = []
      full_credits.css('h4.dataHeaderWithBorder').reject{ |h| h['id'] == 'cast' }.map do |node|
        array << (node.children.size > 1 ? node.children.first.text.strip_whitespace : node.children.text.strip_whitespace)
      end

      array
    end

    def parse_crew_for(category)
      array = []
      table = full_credits.search("[text()^='#{category}']").first.next_element rescue nil

      if table && table.name == 'table'
        table.css('tr').reject do |row|
          # Skip empty table rows with one non-braking space
          row.text.strip.size == 1
        end.map do |row|
          imdb_id = row.first_element_child.at('a')['href'].parse_imdb_id
          name = row.first_element_child.at('a').text.strip_whitespace
          credits_text = row.last_element_child.text.strip_whitespace.clean_credits_text

          array << {
            imdb_id: imdb_id,
            name: name,
            credits_category: category,
            credits_text: credits_text
          }
        end
      end

      array
    end

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

    def release_info
      @release_info ||= open_page("releaseinfo")
    end

    def critic_reviews
      @critic_reviews ||= open_page("criticreviews")
    end

    def still_frames
      @still_frames ||= open_page("mediaindex", { refine: "still_frame" })
    end

    def full_credits
      @full_credits ||= open_page("fullcredits")
    end

    def open_page(page = nil, query = {})
      Spotlite::Client.get("#{@url}#{page}", query: query)
    end
  end
end
