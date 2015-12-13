
require_relative '../lib/turing'
require_relative '../lib/crack'
# Extra characters: !@#$%^&*()[],.<>;:/?\\\|
class Enigma < Turing
  def initialize
    @set = "abcdefghijklmnopqrstuvwxyz0123456789 .,!@#$%^&*()[],.<>;:/?\\\|"
  end

# Testing Key: 37621, Testing Date: 121015
  def encrypt(message = File.read("message.txt"), key = rand.to_s[2..6], date = Time.now.strftime("%-m%d%y").to_i)
    key = key.to_s
    rotation_array = rotation_engine(key_encrypt(key),date_encrypt(date))
    encrypt_i = first_encryption(message)
    rotated_message = rotate(encrypt_i, rotation_array)
    encrypt_ii = second_encryption(rotated_message)
    encrypt_iii = third_encryption(encrypt_ii)
    fourth_encryption(encrypt_iii)
  end

  def key_encrypt(key)
    a = key[0..1].to_i
    b = key[1..2].to_i
    c = key[2..3].to_i
    d = key[3..4].to_i
    key_offset = [a,b,c,d]
    key_offset
  end

  def date_encrypt(date)
    date_offset = (date ** 2).to_s[-4..-1].split("").map {|i| i.to_i}
    date_offset
  end

  def rotation_engine(key_offset,date_offset)
    rotation_array = key_offset.zip(date_offset).map {|i| i.inject(:+)}
    rotation_array
  end

  def first_encryption(message)
    encrypt_i = []
    message.downcase.split("").map do |letter|
      encrypt_i << @set.index(letter)
    end
    encrypt_i
  end

  def rotate(encrypt_i, rotation_array)

    ac = encrypt_i.select.with_index do |x,i|
      x if i % 2 == 0
    end

    bd = encrypt_i.select.with_index do |x,i|
      x if i % 2 != 0
    end

    a = ac.select.with_index do |x,i|
      x if i % 2 == 0
    end.map! {|x| x + rotation_array[0]}

    b = bd.select.with_index do |x,i|
      x if i % 2 == 0
    end.map! {|x| x + rotation_array[1]}

    c = ac.select.with_index do |x,i|
      x if i % 2 != 0
    end.map! {|x| x + rotation_array[2]}

    d = bd.select.with_index do |x,i|
      x if i % 2 != 0
    end.map! {|x| x + rotation_array[3]}

    rotated_message = [a, b, c, d]
    rotated_message
  end

  def second_encryption(rotated_message)
    encrypt_ii = []

    rotated_message[0].each do |x|
      encrypt_ii << x
    end

    first = encrypt_ii.each_with_index.map do |x, i|
      [x,rotated_message[1][i]]
    end

    second = first.each_with_index.map do |x,i|
      [x,rotated_message[2][i]]
    end

    third = second.each_with_index.map do |x,i|
      [x,rotated_message[3][i]]
    end

    encrypt_ii = third.flatten.compact
  end

  def third_encryption(encrypt_ii)
    encrypt_iii = []
    encrypt_iii = encrypt_ii.map do |number|
      # 61 with extra characters, 39 without
      if number <= 61
        number
      else
        number % 61
      end
    end
    encrypt_iii
  end

  def fourth_encryption(encrypt_iii)
    encrypt_iv = []
    encrypt_iii.map do |number|
      encrypt_iv << @set[number]
      end
    encrypted_message = encrypt_iv.join("")
    File.write("encrypted_message.txt", encrypted_message)
    encrypted_message
  end
end
