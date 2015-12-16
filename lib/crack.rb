require_relative '../lib/decrypt'

class Crack < Decrypt

  def crack(encryption = input_encryption, date = Time.now.strftime("%-m%d%y").to_i)
    (crack_array, crack_key) = crack_array_and_key(encryption)
    encryption_rotation = crack_rotation(crack_array, crack_key)
    cracked_key_array =  crack_key_array(encryption_rotation)
    formatted_cracked_key = cracked_key_array_format(cracked_key_array)
    cracked_key = crack_key(formatted_cracked_key)
    cracked_key
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
       if i < 0
         i + 86
       elsif i < 86
         i
       else
         i % 86
       end
     end
  end

  def crack_key_array(encryption_rotation)
    cracked_key_array = encryption_rotation.zip(date_encrypt(@date)).map {|i| i.inject(:-)}
    cracked_key_array
  end

  def find_key(encryption_rotation)
    key = 99999
    until rotation_engine(key_encrypt(key),date_encrypt(@date)) == encryption_rotation
      key -= 1
    end
    key
  end

  def cracked_key_array_format(cracked_key_array)
    cracked_key_array = cracked_key_array.map do |n|
      if n < 0
        n += 86
        n.to_s
      else
        n.to_s
      end
    end
    formatted_cracked_key = cracked_key_array.map do |n|
      if n.length == 1 then n = "0" + n else n
      end
    end
    formatted_cracked_key
  end

  def crack_key(formatted_cracked_key)
    cracked_key =  formatted_cracked_key.join("").split("").select.with_index do |x,i|
      x if i == 0 || i % 2 != 0
    end.join("").to_i
    cracked_key
  end
end


if __FILE__ == $PROGRAM_NAME
e = Crack.new
e.crack
  if ARGV[0] == nil
    ARGV[0] = 'encrypted.txt'
  end
  if ARGV[1] == nil
    ARGV[1] = 'cracked.txt'
  end
puts "Created #{ARGV[1]} from #{ARGV[0]} with the cracked key #{e.key} and date #{e.date}"
end
