require 'cgi'
require 'nokogiri'

module Bot
  class WeatherBot
    def setup
      {
        :syntax => 'weather',
        :description => 'Returns the weather',
        :is_public => true,
        :regex => /(?:weather) (?:is like in|like in|in|for| ?)(.+)$/i
      }
    end

    def block args
      location = args[1].gsub(/( |\?)/, '').split(',').collect { |x| x.capitalize }.join(', ')
      url = "http://www.google.com/ig/api?weather=#{CGI::escape(location)}"
      
      begin
        doc = Nokogiri::HTML(open(url))
      rescue SocketError
        return "An error occurred while getting the information.  Please try again later."
      end
      
      if doc.css('problem_cause').empty?
        current = doc.css('current_conditions temp_c').first.values.first
        high = doc.css('forecast_conditions high').first.values.first.to_celcius
        return "It's currently #{current} °C with an expected high of #{high} °C in #{location}"
      end
    end
  end
end