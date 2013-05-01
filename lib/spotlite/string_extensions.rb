class String
  require 'date' # for Ruby 1.9.2
  
  # Parses date from a string like '20 Jan 2013', 'Mar 2013', or '2013'. 
  # Will return 01-Mar-2013 in case of 'Mar 2013'. 
  # Will return 01-Jan-2013 in case of '2013' 
  def parse_date
    begin
      length > 4 ? Date.parse(self) : Date.new(self.to_i)
    rescue ArgumentError
      nil
    end
  end

  def parse_year # :nodoc:
    year = self[/\d{4}/].to_i
    year > 0 ? year : nil
  end
  
  # Strips 4 digits in braces and a single space before from a string like 'Movie Title (2013)'
  def strip_year
    gsub(/\s\((\d{4})\)/, "")
  end

  # Cleans 'href' param of an <a> tag
  def clean_href
    gsub(/\?ref.+/, "").gsub("/country/", "").gsub("/language/", "")
  end
    
  # Parses 7-digit IMDb ID, usually from a URL
  def parse_imdb_id
    self[/\d{7}/] unless self.nil?
  end

end
