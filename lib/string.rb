class String

  def trim(chars = '\s')
    _trim("^%s*|%s*$", chars)
  end

  def ltrim(chars = '\s')
    _trim("^%s*", chars)
  end

  def rtrim(chars = '\s')
    _trim("%s*$", chars)
  end

  def to_celsius
    i = self.to_f
    sprintf('%0.2f', ((i - 32) / 9) * 5)
  end
  
  def to_fahrenheit
    i = self.to_f
    sprintf('%0.2f', ((i * 9) / 5) + 32)
  end  

  private

  def _trim(regex, chars)
    chars = '\s' if chars.nil?
    chars = Regexp.escape(chars)
    regex.gsub!(/%s/, chars)
    self.gsub(/#{regex}/, '')
  end
end
