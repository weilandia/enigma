
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
    assert_equal [10,14,27,54,17], @e.set_index_translation(@e.encrypt(@message,@key,@date))
  end

  def test_reverse_rotation_engine
    rotation_array = @e.rotation_engine([56,67,73,38], [6,2,2,5])
    assert_equal [-3,-10,-16,-43], @e.reverse_rotation_engine(rotation_array)
  end

  def test_reverse_rotate
    reverse_rotation_array = [-3,-10,-16,-43]
    assert_equal [[7,14], [4], [11], [11]],
    @e.rotate([10,14,27,54,17], reverse_rotation_array)
  end

  def test_second_decryption
    assert_equal [7,4,11,11,14], @e.realign_array([[7,14], [4], [11], [11]])
  end

  def test_third_decryption
    decrypt_ii = [7,4,11,11,14]
    assert_equal "hello", @e.set_translate(decrypt_ii)
  end

  def test_decrypt
    encryption = @e.encrypt("The Sun Also Rises!", "58374", 123015)
    assert_equal "the sun also rises!", @e.decrypt(encryption, "58374", 123015)
  end
end
