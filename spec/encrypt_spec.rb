
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/encrypt'

class EncryptTest < Minitest::Test

  def setup
    @e = Encrypt.new("We can only see a short distance ahead.", Key.new(56738), FormattedDate.new(121215))
  end

  def test_encrypted_key_and_date_rotate_correctly
    assert_equal [62,69,75,43], @e.rotate_encrypted_key_and_date([56,67,73,38], [6,2,2,5])
  end

  def test_message_translates_to_set_numbers
    assert_equal [33,4,11,11,14], @e.translate_message_to_set_numbers("Hello")
  end

  def test_message_rotates_based_on_rotation_array
    assert_equal [[95,76],[73],[86],[54]], @e.rotate_message([33,4,11,11,14],[62,69,75,43])
  end

  def test_message_realigns_to_correct_position
    assert_equal [95,73,86,54,76], @e.realign_message([[95,76],[73],[86],[54]])
  end

  def test_rotated_elements_reduce_to_set
    assert_equal [9,73,0,54,76], @e.modulo_rotated_elements([95,73,86,54,76])
  end

  def test_translate_rotated_message_to_string
    assert_equal "j(a2]", @e.translate_array_to_message([9,73,0,54,76])
  end

  def test_encrypt
    assert_equal "y(ZT ?Z5[:nt:(;t ThY]ait!<h  ?<VM%?V *0", @e.encrypt
  end
end
