require 'spec_helper'

describe "Spotlite::Movie" do
  
  describe "valid movie" do
    
    before(:each) do
      # The Matrix (1999)
      @movie = Spotlite::Movie.new("0133093")
    end
    
    it "should return title" do
      @movie.title.should eql("The Matrix")
    end
    
    describe "original title" do
      it "should return original title if it exists" do
        # City of God (2002)
        @movie = Spotlite::Movie.new("0317248")
        @movie.original_title.should eql("Cidade de Deus")
      end
      
      it "should return nil if it doesn't exist" do
        @movie.original_title.should be_nil
      end
    end
    
    it "should return alternative titles" do
      @movie.alternative_titles.should be_an(Array)
      @movie.alternative_titles.size.should eql(35)
      @movie.alternative_titles.should include({:title => "The Matrix", :comment => "(original title)"})
      @movie.alternative_titles.should include({:title => "Maatriks", :comment => "Estonia"})
      @movie.alternative_titles.should include({:title => "Матрица", :comment => "Russia"})
    end
    
    it "should return original release year" do
      @movie.year.should eql(1999)
    end
    
    it "should return IMDb rating" do
      @movie.rating.should eql(8.7)
    end
    
    it "should return number of votes" do
      @movie.votes.should be_within(150000).of(900000)
    end
    
    it "should return Metascore rating" do
      @movie.metascore.should eql(73)
    end
    
    it "should return description" do
      # A Story about Love (1995)
      @movie = Spotlite::Movie.new("0112873")
      @movie.description.should eql("Two young people stand on a street corner in a run-down part of New York, kissing. Despite the lawlessness of the district they are left unmolested. A short distance away walk Maria and ...")
    end
    
    it "should return storyline" do
      @movie.storyline.should eql("Thomas A. Anderson is a man living two lives. By day he is an average computer programmer and by night a hacker known as Neo. Neo has always questioned his reality, but the truth is far beyond his imagination. Neo finds himself targeted by the police when he is contacted by Morpheus, a legendary computer hacker branded a terrorist by the government. Morpheus awakens Neo to the real world, a ravaged wasteland where most of humanity have been captured by a race of machines that live off of the humans' body heat and electrochemical energy and who imprison their minds within an artificial reality known as the Matrix. As a rebel against the machines, Neo must return to the Matrix and confront the agents: super-powerful computer programs devoted to snuffing out Neo and the entire human rebellion.")
    end
    
    describe "content rating" do
      it "should return MPAA content rating if it's given" do
        @movie.content_rating.should eql("R")
      end
    
      it "should return nil if it's missing" do
        # Rear Window (1954)
        @movie = Spotlite::Movie.new("0047396")
        @movie.content_rating.should be_nil
      end
    end
    
    it "should return genres" do
      @movie.genres.should be_an(Array)
      @movie.genres.size.should eql(2)
      @movie.genres.should include("Action")
      @movie.genres.should include("Sci-Fi")
    end
    
    it "should return countries" do
      @movie.countries.should be_an(Array)
      @movie.countries.size.should eql(2)
      @movie.countries.should include({:code => "us", :name => "USA"})
      @movie.countries.should include({:code => "au", :name => "Australia"})
    end
    
    it "should return languages" do
      @movie.languages.should be_an(Array)
      @movie.languages.size.should eql(1)
      @movie.languages.should include({:code => "en", :name => "English"})
    end
    
    it "should return runtime in minutes" do
      @movie.runtime.should eql(136)
    end
    
    describe "poster URL" do
      it "should return old style poster URL" do
        @movie.poster_url.should eql("http://ia.media-imdb.com/images/M/MV5BMTkxNDYxOTA4M15BMl5BanBnXkFtZTgwNTk0NzQxMTE@.jpg")
      end
      
      it "should return new style poster URL" do
        # American Beauty (1999)
        @movie = Spotlite::Movie.new("0169547")
        @movie.poster_url.should eql("http://ia.media-imdb.com/images/M/MV5BMjM4NTI5NzYyNV5BMl5BanBnXkFtZTgwNTkxNTYxMTE@.jpg")
      end
      
      it "should return nil if poster doesn't exist" do
        # The Flying Circus (1912)
        @movie = Spotlite::Movie.new("0002186")
        @movie.poster_url.should be_nil
      end
    end
    
    it "should return an array of recommended movies as an array of initialized objects of Movie class" do
      @movie.recommended_movies.should be_an(Array)
      @movie.recommended_movies.size.should eql(12)
      @movie.recommended_movies.each {|movie| movie.should be_a(Spotlite::Movie)}
      @movie.recommended_movies.first.imdb_id.should eql("0234215")
      @movie.recommended_movies.first.title.should eql("The Matrix Reloaded")
      @movie.recommended_movies.first.year.should eql(2003)
    end
    
    it "should return plot keywords" do
      @movie.keywords.should be_an(Array)
      @movie.keywords.size.should be_within(50).of(250)
      @movie.keywords.should include("computer", "artificial reality", "hand to hand combat", "white rabbit", "chosen one")
    end
    
    it "should return trivia" do
      @movie.trivia.should be_an(Array)
      @movie.trivia.size.should be_within(10).of(100)
      @movie.trivia.should include("Nicolas Cage turned down the part of Neo because of family commitments. Other actors considered for the role included Tom Cruise and Leonardo DiCaprio.")
      @movie.trivia.should include("Carrie-Anne Moss twisted her ankle while shooting one of her scenes but decided not to tell anyone until after filming, so they wouldn't re-cast her.")
      @movie.trivia.should include("Gary Oldman was considered as Morpheus at one point, as well as Samuel L. Jackson.")
    end
    
    describe "release dates" do
      it "should return release dates" do
        # Rear Window (1954)
        @movie = Spotlite::Movie.new("0047396")
        @movie.release_dates.should be_an(Array)
        @movie.release_dates.size.should be_within(10).of(50)
        @movie.release_dates.should include({:code => "us", :region => "USA", :date => Date.new(1954,8,1), :comment => "New York City, New York, premiere"})
        @movie.release_dates.should include({:code => "jp", :region => "Japan", :date => Date.new(1955,1,29), :comment => nil})
        @movie.release_dates.should include({:code => "tr", :region => "Turkey", :date => Date.new(1956,4,1), :comment => nil})
        @movie.release_dates.detect{ |r| r[:region] == "France" }.should eql({:code => "fr", :region => "France", :date => Date.new(1955,4,1), :comment => nil})
      end
    
      it "should return original release date" do
        @movie.release_date.should eql(Date.new(1999,3,31))
      end
    end
    
    it "should return critic reviews" do
      @movie.critic_reviews.should be_an(Array)
      @movie.critic_reviews.size.should be_within(5).of(15)
      @movie.critic_reviews.should include(
        {
          :source => "Chicago Sun-Times",
          :author => "Roger Ebert",
          :excerpt => "A visually dazzling cyberadventure, full of kinetic excitement, but it retreats to formula just when it's getting interesting.",
          :score => 75
        }
      )
      @movie.critic_reviews.should include(
        {
          :source => "Chicago Tribune",
          :author => "",
          :excerpt => "The writing remains more intelligent than most thrillers, and the action is executed with such panache that even if you don't buy the reality of The Matrix, it's a helluva place to visit.",
          :score => 75
        }
      )
      
      @movie.critic_reviews.should include(
        {
          :source => "Los Angeles Times",
          :author => "Kenneth Turan",
          :excerpt => "A wildly cinematic futuristic thriller that is determined to overpower the imagination, The Matrix combines traditional science-fiction premises with spanking new visual technology in a way that almost defies description.",
          :score => 90
        }
      )
    end
    
    it "should return technical information as a hash of arrays" do
      @movie = Spotlite::Movie.new("0120338")
      hash = @movie.technical
      hash.should be_a(Hash)
      hash.each{|element| element.should be_an(Array)}
      hash.should include("Runtime" => ["3 hr 14 min (194 min)"])
      hash.should include("Sound Mix" => ["DTS 70 mm (70 mm prints)", "DTS", "Dolby Digital", "SDDS"])
      hash.should include("Cinematographic Process" => ["Super 35", "Techniscope (underwater scenes)"])
      hash.should include("Film Length" => ["5,340 m (Sweden)", "5,426 m (10 reels)"])
    end
    
    it "should return an array of still frames URLs" do
      @movie.images.should be_an(Array)
      @movie.images.size.should eql(12)
      @movie.images.should include(
        "http://ia.media-imdb.com/images/M/MV5BMjQ4NTAzNTE2OV5BMl5BanBnXkFtZTcwMjU3MTIxNA@@.jpg",
        "http://ia.media-imdb.com/images/M/MV5BMTAyMDc1MTU0MDBeQTJeQWpwZ15BbWU2MDI5MzU3Nw@@.jpg"
      )
    end
    
    describe "movie credits" do
      it "should return crew categories" do
        @movie.crew_categories.should be_an(Array)
        @movie.crew_categories.size.should eql(27)
        @movie.crew_categories.should include("Directed by", "Writing Credits", "Cinematography by", "Second Unit Director or Assistant Director", "Casting By", "Other crew")
        @movie.crew_categories.should_not include("Cast")
      end
      
      it "should return movie cast" do
        @movie.cast.should be_an(Array)
        @movie.cast.size.should eql(37)
        @movie.cast.each{ |person| person.should be_a(Spotlite::Person) }
        first = @movie.cast.first
        first.name.should eql("Keanu Reeves")
        first.imdb_id.should eql("0000206")
        first.credits_category.should eql("Cast")
        first.credits_text.should eql("Neo")
      end
      
      it "should return movie crew" do
        @movie.crew.should be_an(Array)
        @movie.crew.size.should eql(542)
        @movie.crew.each{ |person| person.should be_a(Spotlite::Person) }
      end
      
      it "should return full credits" do
        @movie.credits.should be_an(Array)
        @movie.credits.size.should eql(@movie.cast.size + @movie.crew.size)
        @movie.credits.each{ |person| person.should be_a(Spotlite::Person) }
      end
      
      it "should parse crew category" do
        category = @movie.parse_crew("Transportation Department")
        category.should be_an(Array)
        category.size.should eql(3)
        first = category.first
        first.name.should eql("John Allan")
        first.imdb_id.should eql("0019956")
        first.credits_category.should eql("Transportation Department")
        first.credits_text.should eql("action vehicle coordinator")
      end
      
      it "should return starred actors" do
        @movie.stars.should be_an(Array)
        @movie.stars.size.should eql(3)
        @movie.stars.each{ |person| person.should be_a(Spotlite::Person) }
        first = @movie.stars.first
        first.name.should eql("Keanu Reeves")
        first.imdb_id.should eql("0000206")
      end
    end
    
  end
  
  describe "#find method" do
    it "should return some movies" do
      results = Spotlite::Movie.find("conan")
      results.should be_an(Array)
      results.size.should eql(200)
      results.each{ |movie| movie.should be_a(Spotlite::Movie) }
      first = results.first
      first.title.should eql("Conan the Barbarian")
      first.imdb_id.should eql("0816462")
    end
    
    it "should return no results" do
      results = Spotlite::Movie.find("wappadoozle swambling")
      results.should be_an(Array)
      results.size.should eql(0)
    end
  end
  
  describe "#search method" do
    it "should return some movies" do
      results = Spotlite::Movie.search({count: 50})
      results.should be_an(Array)
      results.size.should eql(50)
      results.each{ |movie| movie.should be_a(Spotlite::Movie) }
    end
  end
  
end
