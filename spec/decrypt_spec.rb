
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/decrypt'

class DecryptTest < Minitest::Test

  def setup
    @e = Decrypt.new("Hello", Key.new(56738), FormattedDate.new(121215))
  end

  def test_reverses_rotation_array
    rotation_array = @e.rotate_encrypted_key_and_date([56,67,73,38], [6,2,2,5])
    assert_equal [-62,-69,-75,-43], @e.reverse_rotate_encrypted_key_and_date(rotation_array)
  end

  def test_reverses_message_rotation
    reverse_rotation_array = [-62,-69,-75,-43]
    assert_equal [[-53,14],[4],[-75],[11]],
    @e.rotate_message([9,73,0,54,76], reverse_rotation_array)
  end

  def test_third_decryption
    realigned_encryption = [-53,4,-75,11,14]
    assert_equal "Hello", @e.translate_array_to_message(realigned_encryption)
  end

  def test_decrypts_encryption
    encryption = Encrypt.new("The Sun Also Rises", Key.new(56738), FormattedDate.new(121215))

    decrypt_test = Decrypt.new(encryption.encrypt,Key.new(56738),FormattedDate.new(121215))
    
    assert_equal "The Sun Also Rises", decrypt_test.decrypt
  end
end
