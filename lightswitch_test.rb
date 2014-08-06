require_relative 'lightswitch.rb'

class SwitchObserver
  attr_reader :count

  def initialize()
    @count = 0
  end

  def increment_count
    @count = @count + 1
    puts "count=#{@count}"
  end
end

switch = LightSwitch.new
observer = SwitchObserver.new
switch.add_observer(observer)

puts "switch.cout=#{observer.count}"
switch.start
switch.loop_thread.join #wait for the thread to complete
