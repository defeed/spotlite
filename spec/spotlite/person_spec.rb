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
    
    describe "filmography" do
      before(:each) do
        # Quentin Tarantino
        @person = Spotlite::Person.new("0000233")
      end
      
      context "with basic jobs (director, actor, writer, producer), flattened to array" do
        it "should return an array of 76..86 movies" do
          @person.filmography.should be_an(Array)
          @person.filmography.size.should be_within(5).of(81)
          @person.filmography.each{ |movie| movie.should be_a(Spotlite::Movie) }
          @person.filmography.last.title.should eql("My Best Friend's Birthday")
          @person.filmography.last.imdb_id.should eql("0359715")
        end
      end
      
      context "with basic jobs (director, actor, writer, producer), expanded to a hash of arrays" do
        it "should return a hash of 4 arrays with some movies in each of them" do
          @person.filmography(false, false).should be_an(Hash)
          @person.filmography(false, false).size.should eql(4)
          @person.filmography(false, false).keys.should eql([:director, :actor, :writer, :producer])
        end
        
        it "should be able to retrieve individual array by a hash key" do
          @person.filmography(false, false)[:actor].should be_an(Array)
          @person.filmography(false, false)[:actor].size.should be_within(5).of(29)
          @person.filmography(false, false)[:actor].each{ |movie| movie.should be_a(Spotlite::Movie) }
          @person.filmography(false, false)[:actor].last.title.should eql("Love Birds in Bondage")
          @person.filmography(false, false)[:actor].last.imdb_id.should eql("1959459")
        end
      end
      
      context "with all available jobs, flattened to array" do
        it "should return an array of 176..196 movies" do
          @person.filmography(true, true).should be_an(Array)
          @person.filmography(true, true).size.should be_within(10).of(186)
          @person.filmography(true, true).each{ |movie| movie.should be_a(Spotlite::Movie) }
          @person.filmography(true, true).last.title.should eql("The Typewriter, the Rifle & the Movie Camera")
          @person.filmography(true, true).last.imdb_id.should eql("0118004")
        end
      end
      
      context "with all available jobs, expanded to a hash of arrays" do
        it "should return a hash of 11 arrays with some movies in each of them" do
          @person.filmography(true, false).should be_an(Hash)
          @person.filmography(true, false).size.should eql(11)
          @person.filmography(true, false).keys.should eql([:writer, :actor, :director, :producer, :miscellaneous, :soundtrack, :cinematographer, :music_department, :editor, :thanks, :self])
        end
        
        it "should be able to retrieve individual array by a hash key" do
          @person.filmography(true, false)[:thanks].should be_an(Array)
          @person.filmography(true, false)[:thanks].size.should be_within(10).of(75)
          @person.filmography(true, false)[:thanks].each{ |movie| movie.should be_a(Spotlite::Movie) }
          @person.filmography(true, false)[:thanks].last.title.should eql("White Man's Burden")
          @person.filmography(true, false)[:thanks].last.imdb_id.should eql("0114928")
        end
      end
    end
  end
  
end
