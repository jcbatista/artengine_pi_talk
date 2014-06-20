require 'rubygems'
require 'sinatra'
require_relative 'party.rb' 

relay_gpio = 7
set :bind, '0.0.0.0' # allow users to connect to the server

get '/' do
  File.read(File.join('public', 'index.html'))
end

party = Party.new

get '/party/start' do
 party.start
 "Party's started!!!"
end

get '/party/stop' do
 party.stop
 "Party's over!!!"
end

get '/hi' do
  "Hello World!"
end
