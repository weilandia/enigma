
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enigma'
require_relative '../lib/turing'
require_relative '../lib/crack'


class EnigmaTest < Minitest::Test

  def setup
    @e = Enigma.new
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
    assert_equal [74,37,17,17], @e.rotation_engine([73,37,13,8], [1,0,4,9])
  end

  def test_first_encryption
    assert_equal [7,4,11,11,14], @e.first_encryption("Hello")
  end

  def test_rotate
    assert_equal [[81,88],[41],[28],[28]], @e.rotate([7,4,11,11,14],[74,37,17,17])
  end

  def test_second_encryption
    assert_equal [81,41,28,28,88], @e.second_encryption([[81,88],[41],[28],[28]])
  end

  def test_third_encryption
    assert_equal [20,41,28,28,27], @e.third_encryption([81,41,28,28,88])
  end

  def test_fourth_encryption
    assert_equal "u#221", @e.fourth_encryption([20,41,28,28,27])
  end

  def test_encrypt
    assert_equal "xm]&bv]/ot,stmssb^6]pz7seq6bbvq(.iv(bl,", @e.encrypt(@message, @key, @date)
  end
end
