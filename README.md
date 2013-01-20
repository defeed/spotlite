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
    movie.runtime
    => 136
    movie.genres
    => ["Action", "Adventure", "Sci-Fi"]
    > movie.countries
    => [{:code=>"us", :name=>"USA"}, {:code=>"au", :name=>"Australia"}]
    > movie.directors
    => [{:imdb_id=>"0905152", :name=>"Andy Wachowski"}, {:imdb_id=>"0905154", :name=>"Lana Wachowski"}]
    > movie.cast[0..4]
    => [{:imdb_id=>"0000206", :name=>"Keanu Reeves", :character=>"Neo"}, {:imdb_id=>"0000401", :name=>"Laurence Fishburne", :character=>"Morpheus"}, {:imdb_id=>"0005251", :name=>"Carrie-Anne Moss", :character=>"Trinity"}, {:imdb_id=>"0915989", :name=>"Hugo Weaving", :character=>"Agent Smith"}, {:imdb_id=>"0287825", :name=>"Gloria Foster", :character=>"Oracle"}]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
