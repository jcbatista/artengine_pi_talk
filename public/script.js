var Server = function() {
    this.ip = "192.168.0.148";
    this.port = 1000; // default "4567";
    this.url = "http://" + this.ip + ":" + this.port;
    // send a command to the server to turn the light 'on' or 'off'
    this.toggleLight = function(state) {
      var cmd = state ? 'on': 'off';
      var url = this.url + '/light/' + cmd;
      console.log('toggleLight called. state=' + state + ' url=' + url);
      $.ajax({
        url: url,
        type: "GET",
        dataType: "text",
      }).done(function(data) {
        console.log(data);
      }).fail(function(jqXHR, textStatus) {
        console.dir( "Request failed: " + textStatus );
      });
    }
    return this;
  }

var server = new Server();

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
