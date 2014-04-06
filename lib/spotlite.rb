$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "open-uri"
require "nokogiri"

require "spotlite/version"
require "spotlite/movie"
require "spotlite/person"
require "spotlite/list"
require "spotlite/top"
require "spotlite/in_theaters"
require "spotlite/opening_this_week"
require "spotlite/box_office_top"
require "spotlite/coming_soon"
require "spotlite/string_extensions"