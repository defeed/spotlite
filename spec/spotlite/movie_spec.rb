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
      @movie.genres.size.should eql(3)
      @movie.genres.should include("Action")
      @movie.genres.should include("Adventure")
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
        @movie.poster_url.should eql("http://ia.media-imdb.com/images/M/MV5BMjEzNjg1NTg2NV5BMl5BanBnXkFtZTYwNjY3MzQ5.jpg")
      end
      
      it "should return new style poster URL" do
        # American Beauty (1999)
        @movie = Spotlite::Movie.new("0169547")
        @movie.poster_url.should eql("http://ia.media-imdb.com/images/M/MV5BOTU1MzExMDg3N15BMl5BanBnXkFtZTcwODExNDg3OA@@.jpg")
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
      @movie.keywords.should include("computer")
      @movie.keywords.should include("artificial reality")
      @movie.keywords.should include("hand to hand combat")
      @movie.keywords.should include("white rabbit")
      @movie.keywords.should include("chosen one")
    end
    
    it "should return trivia" do
      @movie.trivia.should be_an(Array)
      @movie.trivia.size.should be_within(10).of(100)
      @movie.trivia.should include("Nicolas Cage turned down the part of Neo because of family commitments. Other actors considered for the role included Tom Cruise and Leonardo DiCaprio.")
      @movie.trivia.should include("Carrie-Anne Moss twisted her ankle while shooting one of her scenes but decided not to tell anyone until after filming, so they wouldn't re-cast her.")
      @movie.trivia.should include("Gary Oldman was considered as Morpheus at one point, as well as Samuel L. Jackson.")
    end
    
    it "should return directors" do
      @movie.directors.should be_an(Array)
      @movie.directors.size.should eql(2)
      @movie.directors.should include({:imdb_id => "0905152", :name => "Andy Wachowski"})
      @movie.directors.should include({:imdb_id => "0905154", :name => "Lana Wachowski"})
    end
    
    it "should return writers" do
      @movie.writers.should be_an(Array)
      @movie.writers.size.should eql(2)
      @movie.writers.should include({:imdb_id => "0905152", :name => "Andy Wachowski"})
      @movie.writers.should include({:imdb_id => "0905154", :name => "Lana Wachowski"})
    end
    
    it "should return only unique writers" do
      # The Private Lives of Pippa Lee (2009) 
      @movie = Spotlite::Movie.new("1134629")
      @movie.writers.size.should eql(1)
    end
    
    it "should return producers" do
      @movie.producers.should be_an(Array)
      @movie.producers.size.should eql(10)
      @movie.producers.should include({:imdb_id => "0075732", :name => "Bruce Berman"})
      @movie.producers.should include({:imdb_id => "0185621", :name => "Dan Cracchiolo"})
      @movie.producers.should include({:imdb_id => "0400492", :name => "Carol Hughes"})
      @movie.producers.should include({:imdb_id => "0905152", :name => "Andy Wachowski"})
      @movie.producers.should include({:imdb_id => "0905154", :name => "Lana Wachowski"})
    end
    
    it "should return cast members and characters" do
      @movie.cast.should be_an(Array)
      @movie.cast.size.should eql(37)
      @movie.cast.should include({:imdb_id => "0000206", :name => "Keanu Reeves", :character => "Neo"})
      @movie.cast.should include({:imdb_id => "0000401", :name => "Laurence Fishburne", :character => "Morpheus"})
      @movie.cast.should include({:imdb_id => "0005251", :name => "Carrie-Anne Moss", :character => "Trinity"})
      @movie.cast.should include({:imdb_id => "0915989", :name => "Hugo Weaving", :character => "Agent Smith"})
      @movie.cast.should include({:imdb_id => "3269395", :name => "Rana Morrison", :character => "Shaylae - Woman in Office (uncredited)"})
    end
    
    it "should return starred actors" do
      @movie.stars.should be_an(Array)
      @movie.stars.size.should eql(3)
      @movie.stars.should include({:imdb_id => "0000206", :name => "Keanu Reeves"})
      @movie.stars.should include({:imdb_id => "0000401", :name => "Laurence Fishburne"})
      @movie.stars.should include({:imdb_id => "0005251", :name => "Carrie-Anne Moss"})
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
    
    it "should return an array of still frames URLs" do
      @movie.images.should be_an(Array)
      @movie.images.size.should eql(12)
      @movie.images.should include(
        "http://ia.media-imdb.com/images/M/MV5BMjQ4NTAzNTE2OV5BMl5BanBnXkFtZTcwMjU3MTIxNA@@.jpg",
        "http://ia.media-imdb.com/images/M/MV5BMTAyMDc1MTU0MDBeQTJeQWpwZ15BbWU2MDI5MzU3Nw@@.jpg"
      )
    end
    
  end
  
end
