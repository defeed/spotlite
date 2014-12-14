require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new("spec")
task :default => :spec

desc "Launch irb console"
task :console do
  require 'irb'
  require 'irb/completion'
  require 'spotlite'
  ARGV.clear
  IRB.start
end

desc "Refresh spec fixtures with fresh data from IMDb.com"
task :refresh_fixtures do
  require File.expand_path(File.dirname(__FILE__) + "/spec/spec_helper")

  IMDB_SAMPLES.each_pair do |url, fixture|
    page = `curl -isH "Accept-Language: en-us" '#{url}'`

    File.open(File.expand_path(File.dirname(__FILE__) + "/spec/fixtures/#{fixture}"), 'w') do |f|
      f.write(page)
    end

  end
end
