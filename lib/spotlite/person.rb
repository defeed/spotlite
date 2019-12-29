module Spotlite
  class Person
    attr_accessor :imdb_id, :name

    def initialize(imdb_id, name = nil)
      @imdb_id = "%07d" % imdb_id.to_i
      @name    = name
      @url     = "http://www.imdb.com/name/nm#{@imdb_id}/"
    end

    def name
      @name ||= parser.parse_name
    end

    def birth_name
      @birth_name ||= parser.parse_birth_name
    end

    def birth_date
      @birth_date ||= parser.parse_birth_date
    end

    def death_date
      @death_date ||= parser.parse_death_date
    end

    def birth_place
      @birth_place ||= parser.parse_birth_place
    end

    def death_place
      @death_place ||= parser.parse_death_place
    end

    def photo_url
      @photo_url ||= parser.parse_photo_url
    end

    private

    def parser
      @parser ||= Spotlite::PersonParser.new(imdb_id)
    end
  end
end
