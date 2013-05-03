require 'spec_helper'

describe "Spotlite::ComingSoon" do
  before(:each) do
    @list = Spotlite::ComingSoon.new.movies
  end
  
  it "should return a few results" do
    @list.size.should be_within(14).of(15)
  end
  
  it "should return Spotlite::Movie objects" do
    @list.each { |movie| movie.should be_a(Spotlite::Movie) }
  end
  
  describe "Movie" do
    it "should have IMDb ID" do
      @list.each { |movie| movie.imdb_id.should match(/\d{7}/) }
    end
    
    it "should have title" do
      @list.each { |movie| movie.title.should match(/\w+/) }
    end
    
    it "should have year" do
      @list.each { |movie| movie.year.to_s.should match(/\d{4}/) }
    end
  end
end
