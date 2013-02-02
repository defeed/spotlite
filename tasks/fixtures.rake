namespace :fixtures do
  desc "Refresh spec fixtures with fresh data from IMDb.com"
  task :refresh do
    require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helper")

    IMDB_SAMPLES.each_pair do |url, fixture|
      page = `curl -is #{url} --header "Accept-Language: en-us"`

      File.open(File.expand_path(File.dirname(__FILE__) + "/../spec/fixtures/#{fixture}"), 'w') do |f|
        f.write(page)
      end

    end
  end
end
