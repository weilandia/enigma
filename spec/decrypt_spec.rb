
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/decrypt'

class DecryptTest < Minitest::Test

  def setup
    @e = Decrypt.new
    @message = "Hello"
    @encryption = "ko1:r"
    @key = "56738"
    @date = 121215
  end

  def test_first_decryption
    assert_equal [10,14,27,54,17], @e.first_decryption(@e.encrypt(@message,@key,@date))
  end

  def test_reverse_rotate
    rotation_array = @e.reverse_rotation_engine(@e.key_encrypt("56738"), @e.date_encrypt(121215))
    assert_equal [[7,14], [4], [11], [11]],
    @e.reverse_rotate([10,14,27,54,17], rotation_array)
  end

  def test_second_decryption
    assert_equal [7,4,11,11,14], @e.realign_array([[7,14], [4], [11], [11]])
  end

end
