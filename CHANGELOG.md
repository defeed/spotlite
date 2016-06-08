## v0.8.9 08-Jun-2016

* Added critic review source URL parsing

## v0.8.8 22-May-2016

* Ignore missing taglines placeholder

## v0.8.7 09-May-2016

* Added `taglines` method for `Movie` class to get an array of taglines

## v0.8.6 27-Feb-2016

* Numerous parsing fixes (title, original title, year, rating, metascore, votes, description, genres, runtime, content rating, starred actors)

## v0.8.5 22-Nov-2015

* Added `summaries` method for `Movie` class to get an array of plot summaries

## v0.8.4 17-Nov-2015

* Fixed content rating parsing

## v0.8.3 14-Dec-2014

* Spotlite now uses HTTParty as HTTP client, adding `response` attribute to Movie instance
* Fixed #parse_crew method failing when crew category was missing
* Recommended movies will now include only feature films

## v0.8.2 18-Jul-2014

* Clean some junk from credits text (particularly writers credits)

## v0.8.1 12-Jul-2014

* Added specs for `#find` and `#search` of `Movie` and `Person` classes
* Fix in `Spotlite::Movie#technical`

## v0.8.0 06-Jul-2014

* Added `Spotlite::Movie.search` class method to perform advanced search by parameters
* Added `Spotlite::Movie.find` class method for simple title search
* Added `technical` method for `Movie` class to get movie technical information
* Added `alternative_titles` method for `Movie` class
* Added `Spotlite::Person.search` class method to perform advanced search by parameters
* Added `Spotlite::Person.find` class method for simple name search
* Added `filmography` method for `Person` class
* Moved task to refresh fixtures out of namespace. Now it can be called as `rake refresh_fixtures`
* Added `rake console` task. It will automatically `require 'spotlite'`
* Removed `Spotlite::List` class and all of its subclasses


## v0.7.2 15-Dec-2013

* Fixes for updated Top 250 page
* Fixes for updated person page
* Fixes for updated movie credits page

## v0.7.1 12-Aug-2013

* Updated `images` method following IMDb mediaindex page layout changes

## v0.7.0 04-Aug-2013

* Added `images` method to `Movie` class to fetch still frames from media index page
* Added `recommended_movies` method to `Movie` class that returns a list of, well, recommended movies
* Moved license from LICENSE to README file

## v0.6.2 25-Jul-2013

* Fixed issue when movie description and storyline are cut after a link inside them
* Specified license in gemspec

## v0.6.1 24-Jul-2013

* Fixed issue with new line character in release comments

## v0.6.0 19-Jun-2013

* Added `Person` class
* Added `storyline` method to `Movie` class
* Added `content_rating` method to `Movie` class
* Fixed `release_dates` method following IMDb layout changes
* Added `comment` field to `release_dates` method output

## v0.5.0 03-May-2013

* Added parser for movies coming soon (http://www.imdb.com/movies-coming-soon/)

## v0.4.0 03-May-2013

* Added `metascore` method to `Movie` class
* Added `critic_reviews` method to `Movie` class
* Added parsers for movies opening this week, and this week's box office top 10 (http://www.imdb.com/movies-in-theaters/)
* `Spotlite::Search` now can handle empty search results
* Fixed issue with movie titles not necessarily being in the first table on search results page

## v0.3.0 28-Apr-2013

* Added IMDb Top 250 page parser
* Updated `keywords` method following movie keywords page changes on IMDb

## v0.2.1 21-Apr-2013

* Added `stars` method to get starred actors
* Refactored code
* Fixed issue when original non-english titles were returned in quotes

## v0.2.0 22-Feb-2013
* Added search
* Refreshed fixtures
* Fixed title, original title, and year methods due to IMDb layout changes

## v0.1.1 12-Feb-2013

* Fixed countries, languages, and rating methods due to IMDb layout changes
* Removed method to get MPAA content rating

## v0.1.0 26-Jan-2013

* Initial release. Movie class with methods for most relevant data
