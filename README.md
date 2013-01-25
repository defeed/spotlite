# Spotlite

Spotlite is a ruby gem to retrieve movie information from IMDb.

## Installation

Add this line to your application's Gemfile:

    gem 'spotlite'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spotlite

## Usage

    > require 'spotlite'
    > movie = Spotlite::Movie.new("0133093")
    > movie.title
    => "The Matrix"
    > movie.runtime
    => 136
    > movie.genres
    => ["Action", "Adventure", "Sci-Fi"]
    > movie.countries
    => [{:code=>"us", :name=>"USA"}, {:code=>"au", :name=>"Australia"}]
    > movie.directors
    => [{:imdb_id=>"0905152", :name=>"Andy Wachowski"},
    {:imdb_id=>"0905154", :name=>"Lana Wachowski"}]
    > movie.cast[0..4]
    => [{:imdb_id=>"0000206", :name=>"Keanu Reeves", :character=>"Neo"},
    {:imdb_id=>"0000401", :name=>"Laurence Fishburne", :character=>"Morpheus"},
    {:imdb_id=>"0005251", :name=>"Carrie-Anne Moss", :character=>"Trinity"},
    {:imdb_id=>"0915989", :name=>"Hugo Weaving", :character=>"Agent Smith"},
    {:imdb_id=>"0287825", :name=>"Gloria Foster", :character=>"Oracle"}]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write code
4. Test it (`rake` or `rake spec`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## Testing

Spotlite uses RSpec as a test framework. So, first make sure you have it installed

    $ gem install rspec
    
Run the tests

    $ rake
    
Spotlite uses gem FakeWeb in order to stub out HTTP responses from IMDb. These
stubs are located in `spec/fixtures` directory.

Install FakeWeb gem:

    $ gem install fakeweb

If you want to make a new feature that uses data from a page which is not stubbed out yet:

    $ cd spotlite
    $ curl -is http://www.imdb.com/title/tt[IMDB_ID]/ > spec/fixtures/tt[IMDB_ID]/index
    
or, for example:

    $ curl -is http://www.imdb.com/title/tt[IMDB_ID]/fullcredits > spec/fixtures/tt[IMDB_ID]/fullcredits

You get the idea. And don't forget to add corresponding line to `IMDB_SAMPLES`
hash in `spec/spec_helper.rb` file.

Sometimes IMDb makes changes to its HTML layout. When this happens, Spotlite will not return
expected data, or more likely, methods will return nil or empty arrays.
First, run tests with `LIVE_TEST=true` environment variable:

   $ LIVE_TEST=true rake
   
Adjust methods that are failing, according to the new layout. And refresh fixtures:

   $ rake fixtures:refresh

It will run through all elements of `IMDB_SAMPLES` hash to get fresh data.
