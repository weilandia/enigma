require_relative '../lib/character_set'
require_relative '../lib/formatted_date'
require_relative '../lib/key'

class Encrypt
  attr_reader :key, :date
  def initialize(message = File.read('message.txt'), key = Key.new, date = FormattedDate.new)
    @characters = CharacterSet.new
    @message = message
    @key = key
    @date = date
  end

  def encrypt(message = @message, key = @key, date = @date)

    split_message = translate_message_to_set_numbers(message)

    rotation_array = rotate_encrypted_key_and_date(key.encrypted_key, date.encrypted_date)

    rotated_message = rotate_message(split_message, rotation_array)

    realigned_message = realign_message(rotated_message)

    new_message_array = modulo_rotated_elements(realigned_message)

    new_message = translate_array_to_message(new_message_array)

    File.write('encrypted.txt',new_message)
    File.write('key.txt', @key.key)
    File.write('date.txt', @date.date)

    @encryption = new_message
  end

  def rotate_encrypted_key_and_date(encrypted_key, encrypted_date, characters = @characters)
    rotation_array = encrypted_key.zip(encrypted_date).map do |i|
      i.inject(:+)
    end
    rotation_array = rotation_array.map do |i|
      if i <= characters.set_length - 1 then i else i % characters.set_length end
    end
    rotation_array
  end

  def translate_message_to_set_numbers(message, characters = @characters)
    split_message = message.split("").map do |letter|
      characters.set.index(letter)
    end
    split_message
  end

  def rotate_message(split_message, rotation_array)
    ac = split_message.select.with_index { |x,i| x if i % 2 == 0 }

    bd = split_message.select.with_index { |x,i| x if i % 2 != 0 }

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

  def realign_message(rotated_message)
    realigned_message = rotated_message[0].each do |x|
      [] << x
    end

    first = realigned_message.each_with_index.map do |x, i|
      [x,rotated_message[1][i]]
    end

    second = first.each_with_index.map do |x,i|
      [x,rotated_message[2][i]]
    end

    third = second.each_with_index.map do |x,i|
      [x,rotated_message[3][i]]
    end
    third.flatten.compact
  end

  def modulo_rotated_elements(realigned_message, characters = @characters)
    new_message_array = realigned_message.map do |number|
      number % characters.set_length
    end
    new_message_array
  end

  def translate_array_to_message(new_message_array, characters = @characters)
    new_message = new_message_array.map do |number|
      characters.set[number]
    end.join("")
    new_message
  end
end


# ruby ./lib/encrypt.rb message.txt encrypted.txt
if __FILE__ == $PROGRAM_NAME
e = Encrypt.new(File.read(ARGV[0]))
File.write(ARGV[1], e.encrypt)
puts "Created #{ARGV[1]} from #{ARGV[0]} with the key #{e.key.key} and date #{e.date.date}"
end
