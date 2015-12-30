class CharacterSet
  attr_reader :set, :set_length
  def initialize
    @set = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!@#$%^&*()[]<>;:/?\\\|\'"
    @set_length = @set.length
  end
end
