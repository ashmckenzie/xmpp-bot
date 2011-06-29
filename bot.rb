#!/usr/bin/env ruby

require 'rubygems'
require 'trollop'

require './lib/string.rb'
require './lib/bot.rb'
require './lib/commands/time.rb'
require './lib/commands/weather.rb'
require './lib/commands/temperature.rb'

opts = Trollop::options do
  opt :help, 'Help', :short => 'h'
  opt :config, "Config file to read", :short => 'c', :type => String, :default => Bot::Bot::DEFAULT_CONFIG
  opt :quiet, "Quiet output", :default => Bot::Bot::DEFAULT_QUIET
  opt :debug, "Debug output", :default => Bot::Bot::DEFAULT_DEBUG
end

b = Bot::Bot.new(opts)
b.register([
  Bot::Time.new, 
  Bot::Weather.new,
  Bot::Temperature.new
])
b.connect