require_relative 'mcp3008.rb'

class LightSwitch
public
  def initialize()
    @adc = Mcp3008.new

    relay_gpio = 7 
    @relay_pin = PiPiper::Pin.new(:pin => relay_gpio, :direction => :out)
    @relay_pin.off

    @desired_range = 20
   end

  def action(value)
    puts "value=#{value}"
    @relay_pin.on
  end    

  def start
    initial_value = 0
    value = 0
    previous_value = 0

    wait_cycles = 0
    wait_state = false
    loop do
      value = @adc.read()
      if initial_value == 0
        initial_value = value;
        puts "initial value:#{initial_value}"
      elsif !valueinrange?(value, initial_value) && !valueinrange?(value, previous_value) && !wait_state
        action(value)
        wait_state = true 
        wait_cycles = wait_cycles + 1 
        print "Paused... "
      elsif wait_state
        wait_cycles = (wait_cycles + 1) % 50
        wait_state =  wait_cycles != 0 # end wait_state
        if !wait_state
          puts "Ready!" 
          @relay_pin.off
        end
      end
      #puts "#{wait_state} #{wait_cycles}"
      previous_value = value
      sleep 0.005
    end
  end

private
  def valueinrange?(current, previous)
    #puts "#{current} #{previous} #{range}"
    return (current > (previous - @desired_range)) && (current < (previous + @desired_range))
  end
end 
