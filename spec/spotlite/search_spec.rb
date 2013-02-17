require 'spec_helper'

describe "Spotlite::Search" do
  before(:each) do
    @search = Spotlite::Search.new("the core")
  end
  
  it "should return 8 results" do
    @search.movies.size.should eql(8)
  end
  
  it "should return Spotlite::Movie objects" do
    @search.movies.each { |movie| movie.should be_a(Spotlite::Movie) }
  end
  
  it "should return IMDb ID, title, and year" do
    @search.movies.first.imdb_id.should eql("0298814")
    @search.movies.first.title.should eql("The Core")
    @search.movies.first.year.should eql(2003)
  end
  
  it "should not contain video games" do
    @search.movies.each { |movie| movie.imdb_id.should_not eql("0483593") }
  end
  
  it "should not contain TV series/episodes" do
    @search.movies.each { |movie| movie.imdb_id.should_not eql("1979599") }
  end
end
