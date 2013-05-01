class String
  require 'date' # for Ruby 1.9.2
  
  def parse_date # :nodoc:
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
  
  def strip_year
    gsub(/\s\((\d{4})\)/, "")
  end

  def clean_href # :nodoc:
    gsub(/\?ref.+/, "").gsub("/country/", "").gsub("/language/", "")
  end
    
  def parse_imdb_id # :nodoc:
    self[/\d{7}/] unless self.nil?
  end

end
