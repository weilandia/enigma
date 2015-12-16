require 'simplecov'
SimpleCov.start
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

  def test_crack_array_and_key
    assert_equal [[66, 82, 78, 20], [4, 13, 3, 63]], @e.crack_array_and_key(@e.encrypt(@message,@key,@date))
  end

  def test_crack_rotation
    assert_equal @e.rotation_engine(@e.key_encrypt("56738"),@e.date_encrypt(121215)), @e.crack_rotation([66, 82, 78, 20], [4, 13, 3, 63])
  end

  def test_crack
    skip
  end

end
