require_relative 'string_extensions'

module Spotlite
  class MovieSearchParser
    def initialize(params = {})
      @params = params
    end

    def parse_search
      defaults = {
        title_type: "feature",
        view: "simple",
        count: 250,
        page: 1,
        sort: "moviemeter,asc"
      }

      @params = defaults.merge(@params)
      results = Spotlite::Client.get(
        "http://www.imdb.com/search/title", query: @params
      )

      results.css(".lister-list .lister-item-header").map do |result|
        imdb_id = result.at("a")["href"].parse_imdb_id
        title   = result.at("a").text.strip
        year    = result.at(".lister-item-year").text.parse_year

        [imdb_id, title, year]
      end.map do |values|
        Spotlite::Movie.new(*values)
      end
    end
  end
end
