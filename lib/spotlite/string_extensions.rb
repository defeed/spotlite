class String
  require 'date' if RUBY_VERSION < "1.9.3"

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
    gsub(/\s\(\d{4}\)/, '')
  end

  # Cleans 'href' param of an <a> tag
  def clean_href
    gsub(/(\?|&)ref.+/, '').gsub('/country/', '').gsub('/language/', '')
  end

  # Parses 7-digit IMDb ID, usually from a URL
  def parse_imdb_id
    self[/\d{7}/] unless self.nil?
  end

  # Strip all extra text from person's name node
  def clean_name
    gsub(/\n.+$/, '')
  end

  # Strip a string from all extra white space
  def strip_whitespace
    gsub(/\u00A0/, '').gsub(/\s+/, ' ').strip
  end

  # Removes tagline comment in braces
  def clean_tagline
    gsub(/\[(.*?)\]|\((.*?)\)/, '').strip
  end

  # Strips parantheses from release date's comment
  def clean_release_comment
    gsub("\n", '').gsub(') (', ', ').gsub('(', '').gsub(')', '')
  end

  def clean_credits_text
    gsub(' and', '').gsub(' &', '').gsub(') (', ', ').gsub('(', '').gsub(')', '')
  end

  # Strips "See full summary", "Written by", and "Add a plot" in movie description and storyline
  def clean_description
    gsub(/((?:\sWritten by)(?!.*(?:\sWritten by)).*)/m, '').gsub(/((?:\sSee full summary)(?!.*(?:\sSee full summary)).*)/m, '').gsub('Add a Plot', '').strip
  end

end
