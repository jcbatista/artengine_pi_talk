require 'pi_piper'
#port of the Adafruit MCP3008 interface code found @ http://learn.adafruit.com/send-raspberry-pi-data-to-cosm/python-script

def read_adc(adc_pin, clockpin, adc_in, adc_out, cspin)
  cspin.on
  clockpin.off
  cspin.off
  
  command_out = adc_pin
  command_out |= 0x18
  command_out <<= 3

  (0..4).each do
    adc_in.update_value((command_out & 0x80) > 0)
    command_out <<= 1
    clockpin.on
    clockpin.off
  end
  result = 0

  (0..11).each do
    clockpin.on
    clockpin.off
    result <<= 1
    adc_out.read
    if adc_out.on?
      result |= 0x1
    end
  end 

  cspin.on

  result >> 1
end

def valueinrange?(current, previous, range)
#puts "#{current} #{previous} #{range}"
  return (current > (previous - range)) && (current < (previous + range))
end

clock = PiPiper::Pin.new :pin => 18, :direction => :out
adc_out = PiPiper::Pin.new :pin => 23
adc_in = PiPiper::Pin.new :pin => 24, :direction => :out
cs = PiPiper::Pin.new :pin => 25, :direction => :out

adc_pin = 0
previous_value = 0
value = 0
initial_value = 0;
wait_state = false
wait_cycles = 0
loop do
  value = read_adc(adc_pin, clock, adc_in, adc_out, cs)
  if initial_value == 0
    initial_value = value;
    puts "initial value:#{initial_value}"
  elsif !valueinrange?(value, initial_value, 15) && !valueinrange?(value, previous_value, 15) && !wait_state
    puts "Value = #{value}" # execute command
    wait_state = true
    wait_cycles = wait_cycles + 1 
    print "Paused... "
  elsif wait_state
    wait_cycles = (wait_cycles + 1) % 50
    wait_state =  wait_cycles != 0 # end wait_state
    puts "Ready!" if !wait_state
  end
#puts "#{wait_state} #{wait_cycles}"
  previous_value = value
  sleep 0.01
end
