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
