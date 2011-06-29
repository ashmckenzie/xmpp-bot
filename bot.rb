#!/usr/bin/env ruby

require 'rubygems'
require 'xmpp4r'
require 'xmpp4r-simple'
require 'jabber/bot'
require 'awesome_print'
require 'open-uri'
require 'nokogiri'
require 'yaml'

class String
  def to_celcius
    i = self.to_f
    sprintf('%0.2f', ((i - 32) / 9) * 5)
  end
end

class Bot

  def initialize
    @bot = nil
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
      :status    => "Bot Bot!"
      :is_public => true
    )
  end

  def register_command command
    @bot.add_command(command.setup) do |*args|
      command.block args
    end
  end
end

class BotCommand

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def block args
    @logger.info "#{args[0]}: #{args[1..-1].join(', ')}"
  end
end

class TimeBotCommand < BotCommand

  def setup
    {
      :syntax => 'time',
      :description => 'Returns the current timestamp',
      :is_public => true,
      :regex => /^(time)$/
    }
  end

  def block args
    super args
    Time.now.to_s
  end
end

class WeatherBotCommand < BotCommand

  def setup
    {
      :syntax => 'weather',
      :description => 'Returns the weather',
      :is_public => true,
      :regex => /(?:weather) (?:is like in|like in|in|for| ?)(.+)$/
    }
  end

  def block args
    location = args[1].gsub(/( |\?)/, '').split(',').collect { |x| x.capitalize }.join(', ')
    super args
    url = "http://www.google.com/ig/api?weather=#{CGI::escape(location)}"
    doc = Nokogiri::HTML(open(url))
    if doc.css('problem_cause').empty?
      current = doc.css('current_conditions temp_c').first.values.first
      high = doc.css('forecast_conditions high').first.values.first.to_celcius
      return "It's currently #{current} °C with an expected high of #{high} °C in #{location}"
    end
  end
end

b = Bot.new
b.register_command(TimeBotCommand.new)
b.register_command(WeatherBotCommand.new)
b.connect
