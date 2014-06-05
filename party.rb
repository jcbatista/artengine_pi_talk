require 'thread'

class Party
public
  @should_stop = false
  @party_thread = nil
  
  def party_thread_func 
    puts 'party thread started!'
    while !@should_stop do
      sleep 1
    end
    puts 'party thread stopped!'
  end

  def start
    @party_thread = Thread.new { party_thread_func } 
  end

  def stop
    @should_stop = true
    @party_thread.join
  end
end 

party = Party.new
party.start
sleep 10
party.stop

