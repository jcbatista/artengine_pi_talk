// ex using curl: curl -X PUT -H "Content-Type: application/json" -d '{"action":"stop"}' http://192.168.0.148:8080/api/party
//
var modes = {
              light: { name : "Light", start: "on", stop: "off" },
              party: { name : "Party", start: "start", stop: "stop" }
            }

var Server = function() {
    this.ip = "192.168.0.148";
    this.mode = "party"; // light or party mode 
    this.port = 8080;    // default "4567";

    this.url = "http://" + this.ip + ":" + this.port + "/api";
    // send a command to the server to turn the light (or the Party, depending on the mode) 'on' or 'off'
    this.toggleLight = function(state) {
      var data = { action: state? modes[this.mode].start: modes[this.mode].stop };
      var url = this.url + '/' + this.mode;
      console.log('toggleLight called. state=' + state + ' url=' + url);
      $.ajax({
        url: url,
        type: "PUT",
        dataType: "text",
        contentType: "application/json",
        data: JSON.stringify(data)
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
  // update the switch label depending  on the mode (light or party)
  $('.switch-label').text(modes[server.mode].name + ' Toggle');
});
