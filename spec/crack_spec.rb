require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/crack'

class CrackTest < Minitest::Test

  def setup
    @e = Crack.new
    @message = "Hello ..end.."
    @key = "56738"
    @date = 121215
  end

  def test_read_encryption
    assert_equal File.read("encrypted.txt"), @e.input_encryption
  end

  def test_identify_crack_characters
    @e.encrypt(@message,@key,@date)
    encryption = @e.input_encryption
    require "pry"; binding.pry
    assert_equal [["?", 9], [">", 10], ["u", 11], ["J", 12]], @e.identify_message_length_offset(encryption)
  end

  def test_crack_rotations
    skip
    assert_equal [], @e.crack_rotations([["?", 9], [">", 10], ["u", 11], ["J", 12]])
  end

  def test_crack
    skip
  end

end
