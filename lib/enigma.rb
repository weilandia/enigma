
require_relative '../lib/turing'
require_relative '../lib/crack'
# Extra characters: !@#$%^&*()[],.<>;:/?\|
class Enigma
  attr_reader :encrypted_message
  def initialize
    @set = "abcdefghijklmnopqrstuvwxyz0123456789 .,"
    @date = Time.now.strftime("%m%d%y").to_i
  end

# Testing Key: 37621, Testing Date: 121015
  def encrypt(message = File.read("message.txt"), key=rand.to_s[2..6], date=@date)
    key = key.to_s
    rotation_engine(key_encrypt(key),date_encrypt(date))
    encrypt_i = first_encryption(message)
    rotate(encrypt_i)
    encrypt_ii = second_encryption
    encrypt_iii = third_encryption(encrypt_ii)
    fourth_encryption(encrypt_iii)
  end

  def date_encrypt(date)
    date_offset = (date ** 2).to_s[-4..-1].split("").map {|i| i.to_i}
    date_offset
  end

  def key_encrypt(key)
    a = key[0..1].to_i
    b = key[1..2].to_i
    c = key[2..3].to_i
    d = key[3..4].to_i
    offsets = [a,b,c,d]
    offsets
  end

  def rotation_engine(key_offset,date_offset)
    rotation_array = key_offset.zip(date_offset).map {|i| i.inject(:+)}
    @rotation_a = rotation_array[0]
    @rotation_b = rotation_array[1]
    @rotation_c = rotation_array[2]
    @rotation_d = rotation_array[3]
    rotation_array
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
    encrypt_ii = []

    @a.each do |x|
      encrypt_ii << x
    end

    first = encrypt_ii.each_with_index.map do |x, i|
      [x,@b[i]]
    end

    second = first.each_with_index.map do |x,i|
      [x,@c[i]]
    end

    third = second.each_with_index.map do |x,i|
      [x,@d[i]]
    end

    encrypt_ii = third.flatten.compact
  end

  def third_encryption(input)
    encrypt_iii = []
    encrypt_iii = input.map do |number|
      # 61 with extra characters, 39 without
      if number <= 39
        number
      else
        number % 39
      end
    end
    encrypt_iii
  end

  def fourth_encryption(input)
    encrypt_iv = []
    input.map do |number|
      encrypt_iv << @set[number]
      end
    @encrypted_message = encrypt_iv.join("")
  end
end
