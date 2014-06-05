require_relative 'party.rb' 

party = Party.new
party.start

sleep 5

puts "party state:#{party.party_state}"
puts "light state:#{party.light_state}"

party.stop
