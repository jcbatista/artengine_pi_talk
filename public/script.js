// ex using curl: curl -X PUT -H "Content-Type: application/json" -d '{"action":"stop"}' http://192.168.0.148:8080/api/party
//
var modes = {
              light: { name : "Light", start: "on", stop: "off" },
              party: { name : "Party", start: "start", stop: "stop" }
            }

var Server = function(ip, port, mode) {
    
    this.ip = ip || "192.168.0.148";
    this.port = port || 8080;    // default "4567"
    this.mode = mode || "party"; // light or party mode 

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
