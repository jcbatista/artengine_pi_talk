require 'rubygems'
require 'sinatra'
require 'socket'
require 'json'
require_relative 'lightswitch.rb' 

class SwitchObserver

  attr_reader :count

  def initialize()
    @count = 0
  end

  def increment_count
    @count = @count + 1
    puts "count=#{@count}"
  end

  def crap
    "crap!"
  end
end

set :bind, '0.0.0.0' # allow users to connect to the server

def get_public_ipv4
  # Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and intf.ipv4_private?}
  Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
end

#grab the local IP address
@my_ip = get_public_ipv4().ip_address()
puts "Sinatra running at ip=#{@my_ip}, port=#{settings.port}"
@url = "http://#{@my_ip}:#{settings.port}/count"
puts "url=#{@url}"

# monitor sensor
@switch = LightSwitch.new
observer = SwitchObserver.new
@switch.add_observer(observer)
# start the loop in its own thread
@switch.start

get '/' do
#"hello world!"
  erb :index
end

get '/count' do
   #get count
  observer.count.to_s
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
        console.log("url=<%=@url%>!!!!");
        (function poll(){
             $.ajax({
                      url: "<%=@url%>/count",
                      dataType: "text",
                      complete: setTimeout(poll, 2000),
                      timeout: 30000 
                    })
               .done( function(data) {
                        $('.counter h1').text(data); 
                      });
             })();
        });
  </script>
  <style>
   .counter 
    {
      margin: auto;
      width: 65%;
      text-align:center;
      background-color:rgba(27, 70, 136, 0.14);
    }

    .counter h1 
    {
      font-size: 300px;
    }
  </style>
</head>

<body>
   <div class="counter">
     <h1>0</h1>
   </div>
</body>
</html>
