module StringFormatter

  #format value to $0.0 
  def self.format_currency(value = 0)
    Money.new((value.to_f * 100), "USD").format
  end

  # format date value to ("%B %d, %Y")
  def self.format_date(value = Date.today)
    value.strftime("%B %d, %Y")
  end
end