require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/crack'

class CrackTest < Minitest::Test

  def setup
    @e = Crack.new("Hello ..end..")
    @message = "Hello ..end.."
    @key = "56738"
    @date = 121215
  end

  def test_crack_array_and_key
    assert_equal [[66, 82, 78, 20], [4, 13, 3, 63]], @e.crack_array_and_key(@e.encrypt(@message,@key,@date))
  end

  def test_crack_rotation
    assert_equal @e.rotation_engine(@e.key_encrypt("56738"),@e.date_encrypt(121215)), @e.crack_rotation([66, 82, 78, 20], [4, 13, 3, 63])
  end

  def test_format_cracked_key
    assert_equal "00023", @e.format_cracked_key(23)
  end

  def test_crack_key_encrypt_two
    assert_equal [1, 10, 1, 10], @e.crack_key_encrypt_two(1010)
  end

  def test_crack_key_encrypt_three
    assert_equal [0, 1, 11, 11], @e.crack_key_encrypt_three(111)
  end

  def test_crack_key_encrypt_four
    assert_equal [0, 0, 1, 11], @e.crack_key_encrypt_four(11)
  end

  def test_crack_key_encrypt_five
    assert_equal [0, 0, 0, 1], @e.crack_key_encrypt_five(1)
  end

  def test_crack
    e = Crack.new(@message,"56738",@date)
    assert_equal "56738", e.crack(e.encrypt)
  end

  def test_crack_exact_zero
    e = Crack.new(@message,"03384",@date)
    assert_equal "03384", e.crack(e.encrypt)
  end

  def test_crack_exact_two_zeros
    e = Crack.new(@message,"00767",@date)
    assert_equal "00767", e.crack(e.encrypt)
  end

  def test_crack_exact_three_zeros
    e = Crack.new(@message,"00074",@date)
    assert_equal "00074", e.crack(e.encrypt)
  end

  def test_crack_exact_four_zeros
    e = Crack.new(@message,"00004",@date)
    assert_equal "00004", e.crack(e.encrypt)
  end
end
