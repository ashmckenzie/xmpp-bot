#!/usr/bin/env ruby

require 'rubygems'
require './lib/bot.rb'
require './lib/commands/time.rb'
require './lib/commands/weather.rb'

b = Bot::Bot.new
b.register_command(Bot::TimeBotCommand.new)
b.register_command(Bot::WeatherBotCommand.new)
b.connect