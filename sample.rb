require 'pi_piper'
include PiPiper

relayPin = 7 

pin = PiPiper::Pin.new(:pin => relayPin, :direction => :out)
pin.on
sleep 5
pin.off
