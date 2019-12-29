
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spotlite/version"

Gem::Specification.new do |spec|
  spec.name          = "spotlite"
  spec.version       = Spotlite::VERSION
  spec.authors       = ["Artem Pakk"]
  spec.email         = ["apakk@me.com"]

  spec.description   = %q{Spotlite gem helps you fetch all kinds of publicly available information about movies and people from IMDb movie website, including title, year, genres, directors, writers, actors, runtime, countries, poster, keywords, etc.}
  spec.summary       = %q{Ruby gem to fetch publicly available information about movies from IMDb}
  spec.homepage      = 'http://github.com/defeed/spotlite'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri", "~> 1.8.2"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
