require_relative '../lib/encrypt'

class Decrypt < Encrypt

  def decrypt(encryption = @encryption, key = @key, date = @date)
    decrypt_i = set_index_translation(encryption)
    rotation_array = rotation_engine(key_encrypt(key),date_encrypt(date))
    reverse_rotation_array = reverse_rotation_engine(rotation_array)
    reverse_rotated_message = rotate(decrypt_i, reverse_rotation_array)
    decrypt_ii = realign_array(reverse_rotated_message)
    decrypt_iii = set_translate(decrypt_ii)
    File.write('decrypted.txt', decrypt_iii)
    decrypt_iii
  end

  def reverse_rotation_engine(rotation_array)
    reverse_rotation_array = rotation_array.map do |number|
      if number <= 85 then number * (-1)
      else number % 86 * (-1)
      end
    end
    reverse_rotation_array
  end
end

# ruby ./lib/decrypt.rb encrypted.txt decrypted.txt "20958" 121715
if __FILE__ == $PROGRAM_NAME
e = Decrypt.new(File.read('message.txt'), ARGV[2], ARGV[3].to_i)
File.write(ARGV[0], e.encrypt(@message,@key,@date))
File.write(ARGV[1], e.decrypt(File.read(ARGV[0]), ARGV[2], ARGV[3].to_i))
puts "Created #{ARGV[1]} from #{ARGV[0]} with the key #{ARGV[2]} and date #{ARGV[3]}"
end
