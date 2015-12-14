require_relative '../lib/encrypt'

class Decrypt < Encrypt

  def decrypt(encryption = input_encryption, key = @key.to_s, date = @date)
    reverse_rotation_array = reverse_rotation_engine(key_encrypt(key),date_encrypt(date))
    decrypt_i = first_decryption(encryption)
    reverse_rotated_message = reverse_rotate(decrypt_i, reverse_rotation_array)
    decrypt_ii = realign_array(reverse_rotated_message)
    decrypt_iii = set_translate(decrypt_ii)
    third_decryption(decrypt_iii)
  end

  def first_decryption(encryption)
    decrypt_i = []
    encryption.split("").map do |character|
      decrypt_i << @set.index(character)
    end
    decrypt_i
  end

  def reverse_rotation_engine(key_offset, date_offset)
    rotation_array = rotation_engine(key_offset,date_offset)
    reverse_rotation_array = rotation_array.map do |number|
      if number <= 58
        number
      else
        number % 59
      end
    end
    reverse_rotation_array
  end

  def reverse_rotate(decrypt_i, reverse_rotation_array)

    ac = decrypt_i.select.with_index do |x,i|
      x if i % 2 == 0
    end

    bd = decrypt_i.select.with_index do |x,i|
      x if i % 2 != 0
    end

    a = ac.select.with_index do |x,i|
      x if i % 2 == 0
    end.map! {|x| (reverse_rotation_array[0] - x).abs}

    b = bd.select.with_index do |x,i|
      x if i % 2 == 0
    end.map! {|x| (reverse_rotation_array[1] - x).abs}

    c = ac.select.with_index do |x,i|
      x if i % 2 != 0
    end.map! {|x| (reverse_rotation_array[2] - x).abs}

    d = bd.select.with_index do |x,i|
      x if i % 2 != 0
    end.map! {|x| (reverse_rotation_array[3] - x).abs}

    reverse_rotated_message = [a, b, c, d]
    reverse_rotated_message
  end

  def set_translate(set_index_message)
    set_translate = []
    set_index_message.map do |number|
      set_translate << @set[number]
      end
    message = set_translate.join("")
    message
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
#
# ``ruby
# > require './lib/enigma'
# > e = Enigma.new
# > my_message = "This is so secret!! ..end.."
# > output = e.encrypt(my_message)
# => # encrypted message here
# > output = e.encrypt(my_message, 12345, Date.today) #key and date are optional (gen random key and use today's date)
# => # encrypted message here
# > e.decrypt(output, 12345, Date.today)
# => "This is so secret!! ..end.."
# > e.decrypt(output, 12345) # Date is optional (use today's date)
# => "This is so secret!! ..end.."
# > e.crack(output, Date.today)
# => "This is so secret!! ..end.."
# > e.crack(output) # Date is optional, use today's date
# => "This is so secret!! ..end.."
# ```
#
# ### Working with Files
#
# In addition to the pry form above, we'll want to use the tool
# from the command line like so:
#
# ```
# $ ruby ./lib/encrypt.rb message.txt encrypted.txt
# Created 'encrypted.txt' with the key 82648 and date 030415
# ```
#
# That will take the plaintext file `message.txt` and create an encrypted file `encrypted.txt`.
#
# Then, if we know the key, we can decrypt:
#
# ```
# $ ruby ./lib/decrypt.rb encrypted.txt decrypted.txt 82648 030415
# Created 'decrypted.txt' with the key 82648 and date 030415
# ```
