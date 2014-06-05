require 'thread'
require 'pi_piper'
include PiPiper

class Party
  public

  def initialize
    @should_stop = false
    @party_thread = nil
    relayPin = 7 
    @light_state = false
    @party_state = false
    @pin = PiPiper::Pin.new(:pin => relayPin, :direction => :out)
  end

  def party_thread_func 
    @party_state = true
    puts 'La di da di, we like to party!'
    while !@should_stop do
      if @light_state
        @pin.on
      else
        @pin.off
      end
      puts "light is " + (@light_state ? "on": "off")
      sleep 1
      @light_state = !@light_state; # turn the light on if off (and vice-versa)
    end
    puts 'party thread stopped!'
    @party_state = false
  end

  def start
    if !@party_state
       @party_thread = Thread.new { party_thread_func } 
    else   
       puts "Party's already started..."
    end
  end

  def stop
    if @party_state
      @should_stop = true
      @party_thread.join
    else
      puts "The party hasn't started ... yet!."
    end
  end
end 

party = Party.new
party.start
sleep 3
party.stop

