require 'thread'
require_relative 'mcp3008.rb'

class LightSwitch

public
  attr_reader :observers
  attr_reader :loop_thread

  def initialize()
    @observers = []

    @adc = Mcp3008.new

    relay_gpio = 7 
    @relay_pin = PiPiper::Pin.new(:pin => relay_gpio, :direction => :out)
    @relay_pin.off

    @desired_range = 25
    @loop_thread = nil
   end

  def action(value)
    puts "value=#{value}"
    @relay_pin.on
  end    

  def start
    @loop_thread = Thread.new { thread_func } 
  end

  def thread_func
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
        notify_observers()
        wait_state = true 
        wait_cycles = wait_cycles + 1 
        print "Paused... "
      elsif wait_state
        wait_cycles = (wait_cycles + 1) % 100
        wait_state =  wait_cycles != 0 # end wait_state
        if !wait_state
          puts "Ready!" 
          @relay_pin.off
        end
      end
      #puts "#{wait_state} #{wait_cycles}"
      previous_value = value
      sleep 0.0005
    end
  end

# http://reefpoints.dockyard.com/2013/08/20/design-patterns-observer-pattern.html
  def add_observer(*observers)
    observers.each { |observer| @observers << observer }
  end

  def delete_observer(*observers)
    observers.each { |observer| @observers.delete(observer) }
  end

private

  def notify_observers
    observers.each { |observer| observer.increment_count() }
  end

  def valueinrange?(current, previous)
    #puts "#{current} #{previous} #{@desired_range}"
    return (current > (previous - @desired_range)) && (current < (previous + @desired_range))
  end
end 
