require 'tzinfo'

module Bot
  class TimeBot
    def setup
      {
        :syntax => 'time',
        :description => 'Returns the current timestamp',
        :is_public => true,
        :regex => /^(time)(?:\s*(?:in )(.*))?/i
      }
    end

    def block args
      tz = nil
      zone = args[1][1].gsub(/^\s+|\s+$/, '')
      begin
        tz = TZInfo::Timezone.get(zone)
      rescue TZInfo::InvalidTimezoneIdentifier
        tmp_zone = zone.gsub(/\s+/, '_')
        zones = TZInfo::Timezone.all.select { |x| x.name =~ /#{tmp_zone}/i }
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