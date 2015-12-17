class Encrypt
  attr_reader :key, :date
  def initialize
    @set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!@#$%^&*()[]<>;:/?\\\|\'"
  end

# Testing Key: 37621, Testing Date: 121015
  def encrypt(message = input_message, key = rand.to_s[2..6], date = Time.now.strftime("%-m%d%y").to_i)
    @key = key
    @date = date
    rotation_array = rotation_engine(key_encrypt(key.to_s),date_encrypt(date))
    encrypt_i = set_index_translation(message)
    rotated_message = rotate(encrypt_i, rotation_array)
    encrypt_ii = realign_array(rotated_message)
    encrypt_iii = third_encryption(encrypt_ii)
    encrypt_iv = set_translate(encrypt_iii)
    output_message(encrypt_iv)
  end

  def input_message
    if ARGV[0] == nil
      File.read("message.txt")
    else
      File.read(ARGV[0])
    end
  end

  def key_encrypt(key)
    key = key.to_s
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
    rotation_array = rotation_array.map do |i|
      if i <= 85 then i else i % 86 end
    end
    rotation_array
  end

  def set_index_translation(message)
    set_indices = message.split("").map do |letter|
      @set.index(letter)
    end
    set_indices
  end

  def rotate(encrypt_i, rotation_array)
    ac = encrypt_i.select.with_index { |x,i| x if i % 2 == 0 }

    bd = encrypt_i.select.with_index { |x,i| x if i % 2 != 0 }

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

  def realign_array(rotated_message)
    encrypt_ii = rotated_message[0].each do |x|
      [] << x
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
    encrypt_iii = encrypt_ii.map do |number|
      if number <= 85 then number
      else number % 86
      end
    end
    encrypt_iii
  end

  def set_translate(set_index_message)
    set_translate = set_index_message.map do |number|
      @set[number]
    end.join("")
    set_translate
  end

  def output_message(set_translate)
    if ARGV[1] == nil
      File.write("encrypted.txt", set_translate)
    else
      File.write(ARGV[1], set_translate)
    end
    set_translate
  end
end

# ruby ./lib/encrypt.rb message.txt encrypted.txt
if __FILE__ == $PROGRAM_NAME
e = Encrypt.new
e.encrypt
  if ARGV[0] == nil
    puts "Created 'encrypted.txt' from 'message.txt' with the key #{e.key} and date #{e.date}"
  else
    puts "Created #{ARGV[1]} from #{ARGV[0]} with the key #{e.key} and date #{e.date}"
  end
end
