require_relative 'string_extensions'

module Spotlite
  class PersonParser
    def initialize(imdb_id)
      @imdb_id = imdb_id
      @url     = "http://www.imdb.com/name/nm#{@imdb_id}/"
    end

    def parse_name
      details.at("h1.header span.itemprop").text.strip.clean_name
    end

    def parse_birth_name
      details.at("#name-born-info a[href^='/name/']").text.strip rescue nil
    end

    def parse_birth_date
      details.at("#name-born-info time")['datetime'].parse_date.to_s rescue nil
    end

    def parse_death_date
      details.at("#name-death-info time")['datetime'].parse_date.to_s rescue nil
    end

    def parse_birth_place
      details.at("a[href*='birth_place']").text.strip rescue nil
    end

    def parse_death_place
      details.at("a[href*='death_place']").text.strip rescue nil
    end

    def parse_photo_url
      src = details.at('#img_primary img')['src'] rescue nil

      extract_image_url(src)
    end

    private

    def extract_image_url(src = nil)
      if src =~ /^(https:.+@@)/ || src =~ /^(https:.+?)\.[^\/]+$/
        $1 + ".jpg"
      end
    end

    def details
      @details ||= open_page(nil, { nmdp: 1 })
    end

    def open_page(page = nil, query = {})
      Spotlite::Client.get("#{@url}#{page}", query: query)
    end
  end
end
