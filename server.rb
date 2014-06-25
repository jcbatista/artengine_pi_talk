require 'rubygems'
require 'sinatra'
require 'json'
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
put '/api/light' do
  data = JSON.parse(request.body.read)
  puts "data: #{data}"
  case data["action"]
  when 'on'
    pin.on 
    return "Light on!"
  when 'off'
    pin.off 
    return "Light off!"
  else
    return 'What do you want?'
  end
end

get '/hi' do
  "Hello World!"
end
