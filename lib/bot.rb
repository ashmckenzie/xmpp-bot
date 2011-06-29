require 'xmpp4r-simple'
require 'jabber/bot'
require 'open-uri'
require 'yaml'

class String
  def to_celcius
    i = self.to_f
    sprintf('%0.2f', ((i - 32) / 9) * 5)
  end
end

module Bot
  class Bot
    def initialize
      @bot = nil
      @logger = Logger.new(STDOUT)
      @config = YAML.load_file('bot.yaml')['config']
      setup
    end

    def connect
      @bot.connect
    end

    def setup
      @bot = Jabber::Bot.new(
        :jabber_id => @config['jabber_id'],
        :password  => @config['password'],
        :master    => @config['master'],
        :presence  => :chat,
        :status    => "Bot Bot!",
        :is_public => true
      )
    end

    def register_command command
      @bot.add_command(command.setup) do |*args|
        @logger.info "#{args[0]}: #{args[1..-1].join(', ')}"
        begin
          command.block args
        rescue => e
          @logger.error e.message
          nil
        end  
      end
    end
  end
end