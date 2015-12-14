require_relative '../lib/encrypt'


class Decrypt < Encrypt

  def decrypt(encryption = input_encryption, key = @key.to_s, date = @date)
    decrypt_i = set_index_translation(encryption)
    rotation_array = rotation_engine(key_encrypt(key),date_encrypt(date))
    reverse_rotation_array = reverse_rotation_engine(rotation_array)
    reverse_rotated_message = rotate(decrypt_i, reverse_rotation_array)
    decrypt_ii = realign_array(reverse_rotated_message)
    decrypt_iii = set_translate(decrypt_ii)
    third_decryption(decrypt_iii)
  end

  def reverse_rotation_engine(rotation_array)
    reverse_rotation_array = rotation_array.map do |number|
      if number <= 58
        number * (-1)
      else
        number % 59 * (-1)
      end
    end
    reverse_rotation_array
  end

  def third_decryption(message)
    output_decryption(message)
    message
  end

  def input_encryption
    if ARGV[0] == nil
      File.read("encrypted.txt")
    else
      File.read(ARGV[0])
    end
  end

  def output_decryption(decrypted_message)
    if ARGV[1] == nil
      File.write("decrypted.txt", decrypted_message)
    else
      File.write(ARGV[1], decrypted_message)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
e = Decrypt.new
e.encrypt
e.decrypt
  if ARGV[0] == nil
    ARGV[0] = 'message.txt'
  end
  if ARGV[1] == nil
    ARGV[1] = 'encrypted.txt'
  end
  if ARGV[2] == nil
    ARGV[2] = 'decrypted.txt'
  end
puts "Created #{ARGV[2]} from #{ARGV[1]} with the key #{e.key} and date #{e.date}"
end
