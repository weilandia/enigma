
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/decrypt'

class DecryptTest < Minitest::Test

  def setup
    @e = Decrypt.new
    @message = "Hello"
    @key = "56738"
    @date = 121215
  end

  def test_input_encryption
    require "pry"; binding.pry
    encryption = @e.encrypt(@message,@key,@date)
    assert_equal encryption, @e.input_encryption
  end

  def test_first_decryption
    assert_equal [9,73,0,54,76], @e.set_index_translation(@e.encrypt(@message,@key,@date))
  end

  def test_reverse_rotation_engine
    rotation_array = @e.rotation_engine([56,67,73,38], [6,2,2,5])
    assert_equal [-62,-69,-75,-43], @e.reverse_rotation_engine(rotation_array)
  end

  def test_reverse_rotate
    reverse_rotation_array = [-62,-69,-75,-43]
    assert_equal [[-53,14],[4],[-75],[11]],
    @e.rotate([9,73,0,54,76], reverse_rotation_array)
  end

  def test_second_decryption
    assert_equal [-53,4,-75,11,14], @e.realign_array([[-53,14],[4],[-75],[11]])
  end

  def test_third_decryption
    decrypt_ii = [-53,4,-75,11,14]
    assert_equal "Hello", @e.set_translate(decrypt_ii)
  end

  def test_decrypt
    encryption = @e.encrypt("The Sun Also Rises", "58374", 123015)
    assert_equal "The Sun Also Rises", @e.decrypt(encryption, "58374", 123015)
  end

  def test_output_decryption
    @e.decrypt(@e.encrypt("Hello",@key,@date))
    assert_equal "Hello", File.read('decrypted.txt')
  end
end
