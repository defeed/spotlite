require 'spec_helper'

describe "Find feature" do
  context "Movie" do
    it "should find movies" do
      results = Spotlite::Movie.find("conan")
      results.size.should eql(200)
      results.each{ |result| result.should be_a(Spotlite::Movie) }
      first = results.first
      first.imdb_id.should eql("0816462")
      first.title.should eql("Conan the Barbarian")
      first.year.should eql(2011)
    end

    it "should return emtpy array with no results" do
      results = Spotlite::Movie.find("wappadoozle swambling")
      results.should be_an(Array)
      results.should be_empty
    end
  end

  context "Person" do
    it "should find people" do
      results = Spotlite::Person.find("conan")
      results.size.should eql(200)
      results.each{ |result| result.should be_a(Spotlite::Person) }
      first = results.first
      first.imdb_id.should eql("0000192")
      first.name.should eql("Alyssa Milano")
    end

    it "should return emtpy array with no results" do
      results = Spotlite::Person.find("herpinson derpington")
      results.should be_an(Array)
      results.should be_empty
    end
  end
end
