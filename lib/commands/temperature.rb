module Bot
  class Temperature
    def setup
      {
        :syntax => 'temperature',
        :description => 'Returns the temperature in celcius or fahrenheit',
        :is_public => true,
        :regex => /(temperature) (\d+) (fahrenheit|celsius) in (fahrenheit|celsius)$/i
      }
    end

    def block args
      original = args[1][1]
      original_unit = args[1][2]
      convert_to = args[1][3]
      converted = original.send("to_#{convert_to}")
      "#{original} degrees #{original_unit} is #{converted} degrees #{convert_to} "
    end
  end
end