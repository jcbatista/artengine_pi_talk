require 'rubygems'
require 'sinatra'
require 'pi_piper'
include PiPiper

relay_gpio = 7 
set :bind, '0.0.0.0' # allow users to connect to the server

get '/' do
  File.read(File.join('public', 'index.html'))
end

# initialize the pin for output
pin = PiPiper::Pin.new(:pin => relay_gpio, :direction => :out)

# make sure we start with the light off
pin.off 

get '/light/on' do
 pin.on 
 "light is turned on!"
end

get '/light/off' do
 pin.off 
 "light is turned off!"
end

get '/hi' do
  "Hello World!"
end
