require 'spec_helper'

describe "Spotlite::Movie" do
  
  describe "valid movie" do
    
    before(:each) do
      # The Matrix
      @movie = Spotlite::Movie.new("0133093")
    end
    
    it "should return title" do
      @movie.title.should eql("The Matrix")
    end
    
    it "should return original title" do
      # City of God (Cidade de Deus)
      @movie = Spotlite::Movie.new("0317248")
      @movie.original_title.should eql("Cidade de Deus")
    end
    
    it "should return original release year" do
      @movie.year.should eql(1999)
    end
    
    it "should return IMDb rating" do
      @movie.rating.should eql(8.7)
    end
    
    it "should return number of votes" do
      @movie.votes.should be_within(50000).of(700000)
    end
    
    it "should return description" do
      @movie.description.should match(/A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers./)
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
    
    it "should return runtime" do
      @movie.runtime.should eql(136)
    end
    
    describe "poster URL" do
      it "should return old style poster URL" do
        @movie.poster_url.should eql("http://ia.media-imdb.com/images/M/MV5BMjEzNjg1NTg2NV5BMl5BanBnXkFtZTYwNjY3MzQ5.jpg")
      end
      
      it "should return new style poster URL" do
        # American Beauty
        @movie = Spotlite::Movie.new("0169547")
        @movie.poster_url.should eql("http://ia.media-imdb.com/images/M/MV5BOTU1MzExMDg3N15BMl5BanBnXkFtZTcwODExNDg3OA@@.jpg")
      end
    end
    
    it "should return plot keywords" do
      @movie.keywords.should be_an(Array)
      @movie.keywords.size.should be_within(50).of(250)
      @movie.keywords.should include("Computer")
      @movie.keywords.should include("Artificial Reality")
      @movie.keywords.should include("Hand To Hand Combat")
      @movie.keywords.should include("White Rabbit")
      @movie.keywords.should include("Chosen One")
    end
    
    it "should return trivia" do
      @movie.trivia.should be_an(Array)
      @movie.trivia.size.should be_within(10).of(100)
      @movie.trivia.should include("Nicolas Cage turned down the part of Neo because of family commitments. Other actors considered for the role included Tom Cruise and Leonardo DiCaprio.")
      @movie.trivia.should include("Carrie-Anne Moss twisted her ankle while shooting one of her scenes but decided not to tell anyone until after filming, so they wouldn't re-cast her.")
      @movie.trivia.should include("Gary Oldman was considered as Morpheus at one point, as well as Samuel L. Jackson.")
    end
    
  end
  
end
