require 'spec_helper'

describe "Spotlite::BoxOfficeTop" do
  before(:each) do
    @list = Spotlite::BoxOfficeTop.new.movies
  end
  
  it "should return 10 results" do
    @list.size.should eql(10)
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
