require_relative '../lib/encrypt'

class Decrypt < Encrypt

  def initialize
    @set = "abcdefghijklmnopqrstuvwxyz0123456789 .,!@#$%^&*()[],.<>;:/?\\\|"
  end

  def decrypt(message = input_encryption, key, date)
    @key = key.to_i
    @date = date
    rotation_array = rotation_engine(key_encrypt(key),date_encrypt(date))
    encrypt_i = first_encryption(message)
    rotated_message = rotate(encrypt_i, rotation_array)
    encrypt_ii = second_encryption(rotated_message)
    encrypt_iii = third_encryption(encrypt_ii)
    fourth_encryption(encrypt_iii)
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

e = Encrypt.new
e.encrypt
# e.decrypt
# puts "Created 'decrypted.txt' with the key #{e.key} and date #{e.date}"
