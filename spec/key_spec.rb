require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/key'

class KeyTest < Minitest::Test

  def test_initializes_with_key_and_encrypted_key
    k = Key.new
    refute k.key.nil?
    refute k.encrypted_key.nil?
  end

  def test_key_encrypts_to_correct_array
    k = Key.new("56738")
    assert_equal [56,67,73,38], k.encrypted_key
  end

  def test_key_encrypts_to_correct_array_with_zeros
    k = Key.new("00100")
    assert_equal [00,01,10,00], k.encrypted_key
  end
end
