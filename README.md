[![Gem Version](https://badge.fury.io/rb/spotlite.png)](http://badge.fury.io/rb/spotlite)

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
    # Access movie directly by its IMDb ID
    > movie = Spotlite::Movie.new("0133093")
    # Or use search instead
    > list = Spotlite::Movie.find("the matrix")
    > movie = list.first
    > movie.title
    => "The Matrix"
    > movie.runtime
    => 136
    > movie.genres
    => ["Action", "Sci-Fi"]
    > movie.countries
    => [{:code=>"us", :name=>"USA"}, {:code=>"au", :name=>"Australia"}]
    > movie.directors
    => [#<Spotlite::Person:0x007f96a092be70 @imdb_id="0905152", @name="Andy Wachowski", @url="http://www.imdb.com/name/nm0905152/", @credits_category="Directed by", @credits_text="(as The Wachowski Brothers)">, #<Spotlite::Person:0x007f96a092bda8 @imdb_id="0905154", @name="Lana Wachowski", @url="http://www.imdb.com/name/nm0905154/", @credits_category="Directed by", @credits_text="(as The Wachowski Brothers)">]
    > movie.cast[0..2]
    => [#<Spotlite::Person:0x007f96a19521a0 @imdb_id="0000206", @name="Keanu Reeves", @url="http://www.imdb.com/name/nm0000206/", @credits_category="Cast", @credits_text="Neo">, #<Spotlite::Person:0x007f96a1951c28 @imdb_id="0000401", @name="Laurence Fishburne", @url="http://www.imdb.com/name/nm0000401/", @credits_category="Cast", @credits_text="Morpheus">, #<Spotlite::Person:0x007f96a1951a70 @imdb_id="0005251", @name="Carrie-Anne Moss", @url="http://www.imdb.com/name/nm0005251/", @credits_category="Cast", @credits_text="Trinity">]
    
### IMDb Top 250

    > list = Spotlite::Top.new.movies

### Movies opening this week

    > list = Spotlite::OpeningThisWeek.new.movies

### This week's box office top 10

    > list = Spotlite::BoxOfficeTop.new.movies

### Movies that are coming soon

    > list = Spotlite::ComingSoon.new.movies

## Important notice

Movie titles will be localized if movie has an alternative title specific to your country.
Example: _The Great Gatsby_ (http://www.imdb.com/title/tt1343092) has an alternative title _Gatsby le magnifique_ `France (imdb display title)` and will be localized accordingly based on your IP address, if you reside in France. Non-localized title is still avaliable with `original_title` method.
Sorry, there is nothing I can do about it at the moment.

## Class tree
    
    Spotlite
    |
    |- Movie
    |- Person
    `- List
       |- Top
       `- InTheaters
          |- OpeningThisWeek
          `- BoxOfficeTop

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
    $ curl -isH "Accept-Language: en-us" http://www.imdb.com/title/tt[IMDB_ID]/ > spec/fixtures/tt[IMDB_ID]/index
    
or, for example:

    $ curl -isH "Accept-Language: en-us" http://www.imdb.com/title/tt[IMDB_ID]/fullcredits > spec/fixtures/tt[IMDB_ID]/fullcredits

You get the idea. And don't forget to add corresponding line to `IMDB_SAMPLES`
hash in `spec/spec_helper.rb` file.

Sometimes IMDb makes changes to its HTML layout. When this happens, Spotlite will not return
expected data, or more likely, methods will return nil or empty arrays.
First, run tests with `LIVE_TEST=true` environment variable:

    $ LIVE_TEST=true rake
   
Adjust methods that are failing, according to the new layout. And refresh fixtures:

    $ rake fixtures:refresh

It will run through all elements of `IMDB_SAMPLES` hash to get fresh data.

## License

Copyright (c) 2013 Artem Pakk

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
