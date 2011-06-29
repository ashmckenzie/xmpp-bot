require 'tzinfo'

module Bot
  class TimeBotCommand
    def setup
      {
        :syntax => 'time',
        :description => 'Returns the current timestamp',
        :is_public => true,
        :regex => /^(time)(?:\s*(?:in )(.*))?/
      }
    end

    def block args
      tz = nil
      zone = args[1][1]
      begin
        tz = TZInfo::Timezone.get(zone)
      rescue TZInfo::InvalidTimezoneIdentifier
        zones = TZInfo::Timezone.all.select { |x| x.to_s =~ /#{zone}/ }
        if zones.count == 1
          zone = zones.first.name
          tz = TZInfo::Timezone.get(zone)
        else
          return 'Please be more specific.  e.g Australia/Melbourne'
        end
      end
      "The time in #{zone} is #{tz.now.to_s}"
    end
  end
end