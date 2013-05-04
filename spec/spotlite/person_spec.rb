require 'spec_helper'

describe "Spotlite::Person" do
  
  describe "valid person" do
    
    before(:each) do
      # Heath Ledger
      @person = Spotlite::Person.new("0005132")
    end
    
    it "should return name" do
      @person.name.should eql("Heath Ledger")
    end
    
    it "should return born name if present" do
      @person.birth_name.should eql("Heath Andrew Ledger")
    end
    
    it "should return birth date" do
      @person.birth_date.should be_a(Date)
      @person.birth_date.should eql(Date.new(1979,4,4))
    end
    
    it "should return death date if present" do
      @person.death_date.should be_a(Date)
      @person.death_date.should eql(Date.new(2008,1,22))
    end
    
    describe "photo URL" do
      it "should return old style photo URL" do
        @person.photo_url.should eql("http://ia.media-imdb.com/images/M/MV5BMTI2NTY0NzA4MF5BMl5BanBnXkFtZTYwMjE1MDE0.jpg")
      end
      
      it "should return new style photo URL" do
        # Carey Mulligan
        @person = Spotlite::Person.new("1659547")
        @person.photo_url.should eql("http://ia.media-imdb.com/images/M/MV5BMTQ2MTQyMzYzMV5BMl5BanBnXkFtZTcwODY0ODI4Mg@@.jpg")
      end
      
      it "should return nil if photo doesn't exist" do
        # Natalie Tjern
        @person = Spotlite::Person.new("0864666")
        @person.photo_url.should be_nil
      end
    end    
  end
  
end
