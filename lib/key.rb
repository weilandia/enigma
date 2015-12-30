class Key
  attr_reader :key, :encrypted_key
  def initialize(key = rand.to_s[2..6])
    @key = key
    @encrypted_key = encrypt_key(@key)
  end

  def encrypt_key(key)
    key = key.to_s
    a = key[0..1].to_i
    b = key[1..2].to_i
    c = key[2..3].to_i
    d = key[3..4].to_i
    encrypted_key = [a,b,c,d]
    encrypted_key
  end
end
