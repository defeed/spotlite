$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "rubygems"
require "open-uri"
require "nokogiri"

require "spotlite/version"
require "spotlite/movie"
require "spotlite/list"
require "spotlite/string_extensions"