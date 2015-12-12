
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
  end

  def encrypt(message=File.read("message.txt"))
    encrypt_i = first_encryption(message)
    rotate(encrypt_i)
    second_encryption
    third_encryption(@encrypt_ii)
    fourth_encryption(@encrypt_iii)
    @encrypted_message
  end

  def first_encryption(message)
    encrypt_i = []
    message.downcase.split("").map do |letter|
      encrypt_i << @set.index(letter)
    end
    encrypt_i
  end

  def rotate(input)
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
  end

  def second_encryption
    @encrypt_ii = []

    @a.each do |x|
      @encrypt_ii << x
    end

    first = @encrypt_ii.each_with_index.map do |x, i|
      [x,@b[i]]
    end

    second = first.each_with_index.map do |x,i|
      [x,@c[i]]
    end

    third = second.each_with_index.map do |x,i|
      [x,@d[i]]
    end

    @encrypt_ii = third.flatten.compact
  end

  def third_encryption(input)
    @encrypt_iii = []
    @encrypt_iii = input.map do |number|
      if number <= 61
        number
      else
        number % 61
      end
    end
    @encrypt_iii
  end

  def fourth_encryption(input)
    encrypt_iv = []
    input.map do |number|
      encrypt_iv << @set[number]
      end
    @encrypted_message = encrypt_iv.join("")
  end
end
