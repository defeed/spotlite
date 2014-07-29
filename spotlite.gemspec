# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spotlite/version'

Gem::Specification.new do |gem|
  gem.name          = 'spotlite'
  gem.version       = Spotlite::VERSION
  gem.license       = 'MIT'
  gem.authors       = ['Artem Pakk']
  gem.email         = ['apakk@me.com']
  gem.description   = %q{Spotlite gem helps you fetch all kinds of publicly available information about movies and people from IMDb movie website, including title, year, genres, directors, writers, actors, runtime, countries, poster, keywords, etc.}
  gem.summary       = %q{Ruby gem to fetch publicly available information about movies from IMDb}
  gem.homepage      = 'http://github.com/defeed/spotlite'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  
  gem.add_dependency 'httparty'
  gem.add_dependency 'nokogiri', '~> 1.6'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'fakeweb', '~> 1.3'
end
