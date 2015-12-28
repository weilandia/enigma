require_relative '../lib/decrypt'

class Crack < Decrypt
  attr_reader :cracked_key

  def crack(encryption = File.read('encrypted.txt'))
    (crack_array, crack_key) = crack_array_and_key(encryption)
    encryption_rotation = crack_rotation(crack_array, crack_key)
    key = find_key(encryption_rotation)
    @cracked_key = key
    cracked_message = crack_message(encryption)
    File.write('cracked.txt', cracked_message)
    key
  end

  def crack_array_and_key(encryption)
    if encryption.length <= 7
      crack_array = set_index_translation(encryption[0..3])
      crack_key = [63,63,4,13]
    elsif encryption.length % 4 == 0
      crack_array = set_index_translation(encryption[-4..-1])
      crack_key = [13,3,63,63]
    elsif encryption.length % 4 == 1
      crack_array = set_index_translation(encryption[-5..-2])
      crack_key = [4,13,3,63]
    elsif encryption.length % 4 == 2
      crack_array = set_index_translation(encryption[-6..-3])
      crack_key = [63,4,13,3]
    elsif encryption.length % 4 == 3
      crack_array = set_index_translation(encryption[-7..-4])
      crack_key = [63,63,4,13]
    end
    return crack_array, crack_key
  end

  def crack_rotation(crack_array, crack_key)
    encryption_rotation = []
    element = 0
    4.times do
       if crack_array[element] + crack_key[element] >= 87
         encryption_rotation << 86 + crack_array[element] - crack_key[element] % 86
       else
         encryption_rotation << crack_array[element] - crack_key[element]
       end
       element += 1
    end
    encryption_rotation = encryption_rotation.map do |i|
      if i < 0 then i + 86
      elsif i < 86 then i
      else i % 86
      end
    end
  end

  def find_key(encryption_rotation)
    key = find_key_five_digits(encryption_rotation)
    key = find_key_four_digits(encryption_rotation) if key.to_s.length == 4
    key = find_key_three_digits(encryption_rotation) if key.to_s.length == 3
    key = find_key_two_digits(encryption_rotation) if key.to_s.length == 2
    key = find_key_one_digit(encryption_rotation) if key.to_s.length == 1
    format_cracked_key(key)
  end

  def format_cracked_key(key)
    key = key.to_s
    if key.length == 1
      key = "0000" + key
    elsif key.length == 2
      key = "000" + key
    elsif key.length == 3
      key = "00" + key
    elsif key.length == 4
      key = "0" + key
    else key
    end
    key
  end

  def find_key_five_digits(encryption_rotation)
    key = 99999
    until rotation_engine(key_encrypt(key),date_encrypt(@date)) == encryption_rotation || key == 9999
      key -= 1
    end
    key
  end

  def find_key_four_digits(encryption_rotation)
    key = 9999
    until rotation_engine(crack_key_encrypt_two(key),date_encrypt(@date)) == encryption_rotation || key == 999
      key -= 1
    end
    key
  end

  def find_key_three_digits(encryption_rotation)
    key = 999
    until  rotation_engine(crack_key_encrypt_three(key),date_encrypt(@date)) == encryption_rotation || key == 99
      key -= 1
    end
    key
  end

  def find_key_two_digits(encryption_rotation)
    key = 99
    until rotation_engine(crack_key_encrypt_four(key),date_encrypt(@date)) == encryption_rotation || key == 9
      key -= 1
    end
    key
  end

  def find_key_one_digit(encryption_rotation)
    key = 9
    until  rotation_engine(crack_key_encrypt_five(key),date_encrypt(@date)) == encryption_rotation || key == 0
      key -= 1
    end
    key
  end

  def crack_key_encrypt_two(key)
    key = key.to_s
    a = key[0].to_i
    b = key[0..1].to_i
    c = key[1..2].to_i
    d = key[2..3].to_i
    key_offset = [a,b,c,d]
    key_offset
  end

  def crack_key_encrypt_three(key)
    key = key.to_s
    a = 0
    b = key[0].to_i
    c = key[0..1].to_i
    d = key[1..2].to_i
    key_offset = [a,b,c,d]
    key_offset
  end

  def crack_key_encrypt_four(key)
    key = key.to_s
    a = 0
    b = 0
    c = key[0].to_i
    d = key[0..1].to_i
    key_offset = [a,b,c,d]
    key_offset
  end

  def crack_key_encrypt_five(key)
    key = key.to_s
    a = 0
    b = 0
    c = 0
    d = key[0].to_i
    key_offset = [a,b,c,d]
    key_offset
  end

  def crack_message(encryption)
    decrypt(encryption,@cracked_key,@date)
  end
end

# ruby ./lib/crack.rb encrypted.txt cracked.txt
if __FILE__ == $PROGRAM_NAME
e = Crack.new(File.read('message.txt'), ARGV[2], ARGV[3].to_i)
File.write(ARGV[0], e.encrypt(@message,@key,@date))
File.write(ARGV[1], e.crack)
puts "Created #{ARGV[1]} from #{ARGV[0]} with the cracked key #{e.cracked_key} and date #{e.date}"
end
