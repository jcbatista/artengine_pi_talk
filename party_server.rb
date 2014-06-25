require 'rubygems'
require 'sinatra'
require 'json'

require_relative 'party.rb' 

relay_gpio = 7
set :bind, '0.0.0.0' # allow users to connect to the server

get '/' do
  File.read(File.join('public', 'index.html'))
end

party = Party.new

get '/party/start' do
 party.start
 "You got the party's started!!!"
end

get '/party/stop' do
 party.stop
 "Party's over!!!"
end

put '/party' do
  data = JSON.parse(request.body.read)
  puts data
  case data["action"]
    when 'start' 
      party.start
      return "You got the party's started!!!"
    when 'stop' 
      party.stop
      return "Party's over!!!"
    else
      return 'What do you want?'
  end
end

get '/hi' do
  "Hello World!"
end
