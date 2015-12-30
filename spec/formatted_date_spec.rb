require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/formatted_date'

class FormattedDateTest < Minitest::Test

  def test_initializes_with_date_and_encrypted_date
    d = FormattedDate.new
    refute d.date.nil?
    refute d.encrypted_date.nil?
  end

  def test_date_encrypts_to_correct_array
    d = FormattedDate.new(121215)
    assert_equal [6,2,2,5], d.encrypted_date
  end
end
