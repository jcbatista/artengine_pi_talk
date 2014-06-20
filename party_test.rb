require_relative 'party.rb' 
require 'test/unit'

class PartyTest < Test::Unit::TestCase
  def test_party 
    party = Party.new
    assert !party.party_state
    assert !party.light_state
    # start the party thread twice
    for i in 0..1 do
      party.start
      sleep  3
      assert party.party_state
      assert party.light_state
      puts "party state:#{party.party_state}"
      puts "light state:#{party.light_state}"

      party.stop
      assert !party.party_state
      assert !party.light_state
      puts "party state:#{party.party_state}"
      puts "light state:#{party.light_state}"
    end
  end    
end

