require 'cgi'

module Spotlite
  module SearchResults
    def search_results(query, params)
      page = Nokogiri::HTML open("http://www.imdb.com/find?q=#{CGI::escape(query)}#{url_params}", 'Accept-Language' => 'en-us')
      page.css('.result_text').map do |result|
        imdb_id = result.at('a')['href'].parse_imdb_id
        text    = result.at('a').text.strip
        year    = result.children.take(3).last.text.parse_year if self == Spotlite::Movie
      
        [imdb_id, text, year]
      end.map do |values|
        self.new(*values)
      end
    end    
  end
end
