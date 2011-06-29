module Bot
  class TimeBotCommand
    def setup
      {
        :syntax => 'time',
        :description => 'Returns the current timestamp',
        :is_public => true,
        :regex => /^(time)$/
      }
    end

    def block args
      Time.now.to_s
    end
  end
end