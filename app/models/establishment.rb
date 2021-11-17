class Establishment < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  serialize :availability

  def parse_date(string_date)
    string_date.split(": ")[1].split(" –")
  end

  def open?
    today_times = nil
    self.availability.each do |date|
      today_times = date if date.include?(Time.now.strftime("%A"))
    end
    if today_times.blank?
      return false
    elsif today_times.include?("Closed")
      return false
    elsif today_times.include?("24 hours")
      return true
    else
      opening = Chronic.parse("this #{parse_date(today_times)[0]}")
      closing = Chronic.parse("this #{parse_date(today_times)[1]}")
      return Time.now > opening && Time.now < closing
    end
  end
end
