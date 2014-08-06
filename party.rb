require 'thread'
require 'pi_piper'
include PiPiper

class Party

public

  attr_reader :party_state
  attr_reader :light_state

  def initialize
    @mutex = Mutex.new
    @should_stop = false
    @party_thread = nil
    @light_state = false
    @party_state = false
    relayPin = 7 
    @pin = PiPiper::Pin.new(:pin => relayPin, :direction => :out)
  end

  def start
    @mutex.synchronize do
      if !@party_state
        @party_state = true
        @should_stop = false
        @party_thread = Thread.new { party_thread_func } 
      else   
        puts "Yo! The party's already started..."
      end
    end
  end

  def stop
    @mutex.synchronize do 
      if @party_state
        @party_state = false
        @should_stop = true # make the party thread stop
        @party_thread.join  # wait for the party thread to actually stop
        light_off # make sure the light is off when the party stops
      else
        puts "The party hasn't started ... yet!."
      end
    end 
  end

private

  def light_on
    @pin.on
    @light_state = true
  end

  def light_off
    @pin.off
    @light_state = false
  end

  def party_thread_func 
    puts 'La di da di, we like to party!'
    while !@should_stop do
      if @light_state
        light_off
      else
        light_on
      end
      puts 'light is ' + (@light_state ? 'on': 'off')
      sleep 1
    end
    puts 'party thread stopped!'
  end
  
end 

