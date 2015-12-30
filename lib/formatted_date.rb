class FormattedDate
  attr_reader :date, :encrypted_date
  def initialize(date = Time.now.strftime("%-m%d%y").to_i)
    @date = date
    @encrypted_date = date_encrypt(@date)
  end

  def date_encrypt(date)
    encrypted_date = (date ** 2).to_s[-4..-1].split("").map {|i| i.to_i}
    encrypted_date
  end
end
