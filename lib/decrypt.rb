require_relative '../lib/encrypt'

class Decrypt < Encrypt

  def decrypt(encryption = input_encryption, key = @key, date = @date)
    decrypt_i = set_index_translation(encryption)
    rotation_array = rotation_engine(key_encrypt(key),date_encrypt(date))
    reverse_rotation_array = reverse_rotation_engine(rotation_array)
    reverse_rotated_message = rotate(decrypt_i, reverse_rotation_array)
    decrypt_ii = realign_array(reverse_rotated_message)
    decrypt_iii = set_translate(decrypt_ii)
    output_decryption(decrypt_iii)
  end

  def input_encryption
    if ARGV[0] == nil then File.read("encrypted.txt")
    else File.read(ARGV[0])
    end
  end

  def reverse_rotation_engine(rotation_array)
    reverse_rotation_array = rotation_array.map do |number|
      if number <= 85 then number * (-1)
      else number % 86 * (-1)
      end
    end
    reverse_rotation_array
  end

  def output_decryption(decrypted_message)
    if ARGV[1] == nil then File.write("decrypted.txt", decrypted_message)
    else File.write(ARGV[1], decrypted_message)
    end
    decrypted_message
  end
end

# ruby ./lib/decrypt.rb encrypted.txt decrypted.txt [key] [date]
if __FILE__ == $PROGRAM_NAME
e = Decrypt.new
e.encrypt
e.decrypt
  if ARGV[0] == nil
    puts "Created 'decrypted.txt' from 'encrypted.txt' with the key #{e.key} and date #{e.date}"
  else
    puts "Created #{ARGV[1]} from #{ARGV[0]} with the key #{ARGV[2]} and date #{ARGV[3]}"
  end
end
