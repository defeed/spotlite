require 'spec_helper'

describe "Spotlite::Top" do
  before(:each) do
    @top = Spotlite::Top.new.movies
  end
  
  it "should return 250 results" do
    @top.size.should eql(250)
  end
  
  it "should return Spotlite::Movie objects" do
    @top.each { |movie| movie.should be_a(Spotlite::Movie) }
  end
  
  it "should return IMDb ID and title" do
    @top.first.imdb_id.should eql("0111161")
    @top.first.title.should eql("The Shawshank Redemption")
  end  
end
