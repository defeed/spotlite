require "bundler/gem_tasks"
require "rspec/core/rake_task"

load File.expand_path(File.dirname(__FILE__) + "/tasks/fixtures.rake")

RSpec::Core::RakeTask.new("spec")

task :default => :spec
