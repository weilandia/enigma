require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/character_set'

class CharacterSetTest < Minitest::Test

  def test_initializes_with_character_set_and_set_length
    s = CharacterSet.new
    refute s.set.nil?
    refute s.set_length.nil?
  end

  
end
