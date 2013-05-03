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
