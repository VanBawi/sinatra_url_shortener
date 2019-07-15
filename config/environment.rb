require 'bundler/setup'
Bundler.require

ENV['SINATRA_ENV'] ||= "development"
require 'dotenv'
Dotenv.load

require_all 'app'
