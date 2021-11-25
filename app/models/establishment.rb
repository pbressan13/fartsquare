class Establishment < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  serialize :availability
  searchkick

  def parse_date(string_date)
    string_date.split(": ")[1].split(" –")
  end

  def fetch_today_times
    today_times = nil

    availability.each do |date|
      today_times = date if date.include?(Time.now.strftime("%A"))
    end

    return today_times
  end

  def open?
    today_times = fetch_today_times

    return false if today_times.blank? || today_times.include?("Closed")
    return true if today_times.include?("24 hours")

    opening = Chronic.parse("this #{parse_date(today_times).first}")
    closing = Chronic.parse("this #{parse_date(today_times).last}")
    return Time.now > opening && Time.now < closing
  end
end
