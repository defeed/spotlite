require 'rspec'
require 'spotlite'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

def read_fixture(path)
  File.read(File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', path)))
end

IMDB_SAMPLES = {
  'http://www.imdb.com/title/tt0133093/'                              => 'tt0133093/index',
  'http://www.imdb.com/title/tt0133093/fullcredits'                   => 'tt0133093/fullcredits',
  'http://www.imdb.com/title/tt0133093/keywords'                      => 'tt0133093/keywords',
  'http://www.imdb.com/title/tt0133093/releaseinfo'                   => 'tt0133093/releaseinfo',
  'http://www.imdb.com/title/tt0133093/trivia'                        => 'tt0133093/trivia',
  'http://www.imdb.com/title/tt0133093/criticreviews'                 => 'tt0133093/criticreviews',
  'http://www.imdb.com/title/tt0317248/'                              => 'tt0317248/index',
  'http://www.imdb.com/title/tt0169547/'                              => 'tt0169547/index',
  'http://www.imdb.com/title/tt0112873/'                              => 'tt0112873/index',
  'http://www.imdb.com/title/tt0047396/releaseinfo'                   => 'tt0047396/releaseinfo',
  'http://www.imdb.com/title/tt0002186/'                              => 'tt0002186/index',
  'http://www.imdb.com/title/tt1134629/fullcredits'                   => 'tt1134629/fullcredits',
  'http://www.imdb.com/find?q=conan&s=tt&ttype=ft'                    => 'movie_find_conan',
  'http://www.imdb.com/find?q=wappadoozle+swambling&s=tt&ttype=ft'    => 'movie_find_no_results',
  'http://www.imdb.com/find?q=herpinson+derpington&s=nm'              => 'person_find_no_results',
  'http://www.imdb.com/find?q=conan&s=nm'                             => 'person_find_conan',
  'http://www.imdb.com/chart/top'                                     => 'top',
  'http://www.imdb.com/movies-in-theaters/'                           => 'movies_in_theaters',
  'http://www.imdb.com/movies-coming-soon/'                           => 'movies_coming_soon',
  'http://www.imdb.com/name/nm0000233/?nmdp=1'                        => 'nm0000233/index',
  'http://www.imdb.com/name/nm0005132/?nmdp=1'                        => 'nm0005132/index',
  'http://www.imdb.com/name/nm1659547/?nmdp=1'                        => 'nm1659547/index',
  'http://www.imdb.com/name/nm0864666/?nmdp=1'                        => 'nm0864666/index',
  'http://www.imdb.com/title/tt0133093/mediaindex?refine=still_frame' => 'tt0133093/mediaindex_still_frame'
}

unless ENV['LIVE_TEST']
  begin
    require 'rubygems'
    require 'fakeweb'

    FakeWeb.allow_net_connect = false
    IMDB_SAMPLES.each do |url, response|
      FakeWeb.register_uri(:get, url, :response => read_fixture(response))
    end
  rescue LoadError
    puts 'Could not load FakeWeb, these tests will hit IMDb.com'
    puts 'You can run `gem install fakeweb` to stub out the responses.'
  end
end
