require 'rubygems'
require 'sinatra'
require 'socket'
require 'json'
require_relative 'party.rb' 

relay_gpio = 7
set :bind, '0.0.0.0' # allow users to connect to the server

def get_public_ipv4
  # Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and intf.ipv4_private?}
  Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
end

my_ip = get_public_ipv4().ip_address()
puts "Sinatra running at ip=#{my_ip}, port=#{settings.port}"

get '/' do
  File.read(File.join('public', 'index.html'))
end

party = Party.new

put '/api/party' do
  data = JSON.parse(request.body.read)
  puts "data: #{data}"
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
