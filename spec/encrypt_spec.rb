
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/encrypt'

class EncryptTest < Minitest::Test

  def setup
    @e = Encrypt.new
    @message = "We can only see a short distance ahead."
    @key = "56738"
    @date = 121215
  end

  def test_key_encrypt
    assert_equal [56,67,73,38], @e.key_encrypt(@key)
  end

  def test_date_encrypt
    assert_equal [6,2,2,5], @e.date_encrypt(@date)
  end

  def test_rotation_engine
    assert_equal [62,69,75,43], @e.rotation_engine([56,67,73,38], [6,2,2,5])
  end

  def test_first_encryption
    assert_equal [33,4,11,11,14], @e.set_index_translation("Hello")
  end

  def test_rotate
    assert_equal [[95,76],[73],[86],[54]], @e.rotate([33,4,11,11,14],[62,69,75,43])
  end

  def test_realign_array
    assert_equal [95,73,86,54,76], @e.realign_array([[95,76],[73],[86],[54]])
  end

  def test_third_encryption
    assert_equal [9,73,0,54,76], @e.third_encryption([95,73,86,54,76])
  end

  def test_set_translate
    assert_equal "j(a2]", @e.set_translate([9,73,0,54,76])
  end

  def test_encrypt
    require "pry"; binding.pry
    assert_equal "y(ZT ?Z5[:nt:(;t ThY]ait!<h  ?<VM%?V *0", @e.encrypt(@message, @key, @date)
  end
end
