
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enigma'
require_relative '../lib/turing'
require_relative '../lib/crack'


class EnigmaTest < Minitest::Test

  def test_encrypt
    e = Enigma.new
    assert_equal e.encrypt("A long, long time ago...  ..end.."), ".<o@]x#b)5q6m l,#<d6,>@cm<@c#4gcn"
  end
end
