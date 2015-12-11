
require_relative '../lib/turing'
require_relative '../lib/crack'

class Enigma
  attr_accessor :encrypt_i
  def initialize
    @set = "abcdefghijklmnopqrstuvwxyz0123456789 .,!@#$%^&*()[],.<>;:/?\|"
    @rotation_a = 37
    @rotation_b = 78
    @rotation_c = 64
    @rotation_d = 26
    @a = @b = @c = @d = []
  end

  def encrypt(message)
    @message = message
    first_encryption
    @encrypted_message
  end

  def first_encryption
    @encrypt_i = []
    @message.downcase.split("").map do |letter|
      @encrypt_i << @set.index(letter)
      end
    rotate
  end

  def rotate(input=self.encrypt_i)
    ac = input.select.with_index do |x,i|
      x if i % 2 == 0
    end

    bd = input.select.with_index do |x,i|
      x if i % 2 != 0
    end

    @a = ac.select.with_index do |x,i|
      x if i % 2 == 0
    end.map! {|x| x + @rotation_a}

    @b = bd.select.with_index do |x,i|
      x if i % 2 == 0
    end.map! {|x| x + @rotation_b}

    @c = ac.select.with_index do |x,i|
      x if i % 2 != 0
    end.map! {|x| x + @rotation_c}

    @d = bd.select.with_index do |x,i|
      x if i % 2 != 0
    end.map! {|x| x + @rotation_d}
    second_encryption
  end

  def second_encryption
    @encrypt_ii = []

    @a.each do |x|
      @encrypt_ii << x
    end

    @first = @encrypt_ii.each_with_index.map do |x, i|
      [x,@b[i]]
    end

    @second = @first.each_with_index.map do |x,i|
      [x,@c[i]]
    end

    @third = @second.each_with_index.map do |x,i|
      [x,@d[i]]
    end

    @encrypt_ii = @third.flatten.compact
    third_encryption
  end

  def third_encryption
    @encrypt_iii = []
    @encrypt_iii = @encrypt_ii.map do |number|
      if number <= 61
        number
      else
        number % 61
      end
    end
    fourth_encryption
  end

  def fourth_encryption
    @encrypt_iv = []
    @encrypt_iii.map do |number|
      @encrypt_iv << @set[number]
      end
    @encrypted_message = @encrypt_iv.join("")
  end
end
