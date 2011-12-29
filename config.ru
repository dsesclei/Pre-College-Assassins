require "bundler"

Bundler.require
log = File.new("./sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)
require "./assassins.rb"
run Sinatra::Application
