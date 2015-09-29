require 'sinatra'
require 'sinatra/reloader'
require 'json'

require_relative 'gw2-api.rb'

get '/debug' do
  content_type :json

  debug = GuildWars.debug
  puts debug
  debug.to_json
end

