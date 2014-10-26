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

#grab the local IP address
$my_ip = get_public_ipv4().ip_address()

puts "Sinatra running at ip=#{$my_ip}, port=#{settings.port} ..."

get '/' do
  erb :index
end

party = Party.new

get '/api/party' do
  return party.info.to_json
end

post '/api/party' do
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

__END__

@@index
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Pi GPIO test</title>
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto">

  <link rel="stylesheet" href="party.css">
  <link rel="stylesheet" href="onoffswitch.css">

  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script type="text/javascript" src="script.js"></script>

  <script type="text/javascript">
    var server = new Server("<%=$my_ip%>", <%=settings.port%>, "party");

    console.log("server url=" + server.url);

    $(document).ready(function() {
      // click handlerr to the on/off switch <= that's just a checkbox
      var $switch = $('#myonoffswitch');
      $switch.on('click', function() {
        var state = $switch.is(':checked');
        console.log(state);
        server.toggleLight(state);
      });
    });
  </script>
</head>

<body>
   <div class="party-section">
      <div class="party-section-inner">
         <div class="switch-label">
            Party Toggle
         </div>
         <!-- I shamelessly borrowed the switch from http://proto.io/freebies/onoff/ ;) -->
         <div class="onoffswitch">
            <input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="myonoffswitch">
            <label class="onoffswitch-label" for="myonoffswitch">
               <span class="onoffswitch-inner"></span>
               <span class="onoffswitch-switch"></span>
            </label>
         </div>
      </div>
   </div>
</body>
</html>
