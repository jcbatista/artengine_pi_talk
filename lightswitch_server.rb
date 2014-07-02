require 'rubygems'
require 'sinatra'
require 'socket'
require 'json'
require_relative 'lightswitch.rb' 

set :bind, '0.0.0.0' # allow users to connect to the server

def get_public_ipv4
  # Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and intf.ipv4_private?}
  Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
end

#grab the local IP address
@my_ip = get_public_ipv4().ip_address()
puts "Sinatra running at ip=#{@my_ip}, port=#{settings.port}"
@url = "#{@my_ip}:#{settings.port}/count"
puts "url=#{@url}"

get '/' do
  erb :index
end

__END__

@@index
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Pi GPIO test</title>
  <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Roboto">
<!--
  <link rel="stylesheet" href="party.css">
  <link rel="stylesheet" href="onoffswitch.css">
-->
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

  <script type="text/javascript">

    $(document).ready(function() {
        (function poll(){
             $.ajax({ url: "server", success: function(data){
                      console.dir("data:"+data); 
                      //$('.counter.h1'). 

                           }, dataType: "json", complete: poll, timeout: 30000 });
             })();
        });
  </script>
  <style>
.counter.h1 
{
  font-size: 44px;
}
  </style>
</head>

<body>
   <div class="counter">
     <h1>0</h1>
   </div>
</body>
</html>
