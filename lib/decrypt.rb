require_relative '../lib/encrypt'

class Decrypt < Encrypt

  attr_reader :key, :date
  def initialize(encryption = File.read('encrypted.txt'), key = Key.new(File.read('key.txt')), date = FormattedDate.new(File.read('date.txt').to_i))
    @characters = CharacterSet.new
    @encryption = encryption
    @key = key
    @date = date
  end

  def decrypt(encryption = @encryption, key = @key, date = @date)

    split_message = translate_message_to_set_numbers(encryption)

    rotation_array = rotate_encrypted_key_and_date(key.encrypted_key, date.encrypted_date)

    reverse_rotation_array = reverse_rotate_encrypted_key_and_date(rotation_array)

    reverse_rotated_encryption = rotate_message(split_message, reverse_rotation_array)

    realigned_encryption = realign_message(reverse_rotated_encryption)

    decrypted_message = translate_array_to_message(realigned_encryption)

    File.write('decrypted.txt', decrypted_message)

    decrypted_message
  end

  def reverse_rotate_encrypted_key_and_date(rotation_array, characters = @characters)
    reverse_rotation_array = rotation_array.map do |number|
      if number <= characters.set_length - 1 then number * (-1)
      else number % characters.set_length * (-1)
      end
    end
    reverse_rotation_array
  end
end

# ruby ./lib/decrypt.rb encrypted.txt decrypted.txt
if __FILE__ == $PROGRAM_NAME
e = Decrypt.new(File.read(ARGV[0]), Key.new(File.read('key.txt')),FormattedDate.new(File.read('date.txt').to_i))

File.write(ARGV[1], e.decrypt)

puts "Created #{ARGV[1]} from #{ARGV[0]} with the key #{File.read('key.txt')} and date #{File.read('date.txt')}"
end
