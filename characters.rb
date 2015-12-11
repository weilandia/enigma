

p @set.split("")
["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " ", ".", ",", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "[", "]", ",", ".", "<", ">", ";", ":", "/", "?", "|"]

Extension:
`!@#$%^&*()[],.<>;:/?\|`
____
# class Encrypt(key,date,input_file)
# def initialize()
#   @key = key
    #@date = date
# end
# #e = Encrypt.new("static key","static date") --for Testing
##e = Encrypt.new()
@set = "abcdefghijklmnopqrstuvwxyz0123456789 .,!@#$%^&*()[],.<>;:/?\|"
# pass in Random.rand(0..9).to_i to encrypt

@first_encrypt = []
@second_encrypt = []
@third_encrypt = []
@fourth_encrypt = []
# @encrypted_message attr_accessor
@a = []
@b = []
@c = []
@d = []
@rotation_a = 37
@rotation_b = 78
@rotation_c = 64
@rotation_d = 26

# def key_rotation
#   @a_key_rotation = @key[0..1].to_i
# end
#
# def date_offset
#   @date = Time.now.strftime(%d%m%y)
#   date_offset =

def parse_and_first_encryption(input)
  input.downcase.split("").map do |letter|
    @first_encrypt << @set.index(letter)
    @first_encrypt.map! do |number|
      number.to_i
    end
  end
  @first_encrypt
end

def find_abcd(input=@first_encrypt)
  ac = input.select.with_index do |x,i|
    x if i % 2 == 0
  end

  bd = input.select.with_index do |x,i|
    x if i % 2 != 0
  end

  @a = ac.select.with_index do |x,i|
    x if i % 2 == 0
  end.map! {|x| x + @rotation_a}

  @b = bd.select.with_index do |x,i|
    x if i % 2 == 0
  end.map! {|x| x + @rotation_b}

  @c = ac.select.with_index do |x,i|
    x if i % 2 != 0
  end.map! {|x| x + @rotation_c}

  @d = bd.select.with_index do |x,i|
    x if i % 2 != 0
  end.map! {|x| x + @rotation_d}

  @a.each do |x|
    @second_encrypt << x
  end

  @first = @second_encrypt.each_with_index.map do |x, i|
    [x,@b[i]]
  end

  @second = @first.each_with_index.map do |x,i|
    [x,@c[i]]
  end

  @third = @second.each_with_index.map do |x,i|
    [x,@d[i]]
  end

  @second_encrypt = @third.flatten.compact
end

def third_encrypt
  @third_encrypt = @second_encrypt.map do |number|
    if number <= 61
      number
    else
      number % 61
    end
  end
end

def reverse_parse_and_fourth_encryption(input = @third_encrypt)
  input.map do |number|
    @fourth_encrypt << @set[number]
    end
  @encrypted_message = @fourth_encrypt.join("")
end

parse_and_first_encryption("Nick Weiland")
