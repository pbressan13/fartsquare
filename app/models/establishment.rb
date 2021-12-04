class Establishment < ApplicationRecord
  belongs_to :user
  has_one :bathroom, dependent: :destroy
  has_many_attached :images
  serialize :availability
  searchkick
  serialize :types
  geocoded_by :street_address
  # after_validation :geocode, if: :will_save_change_to_address?

  validates :name, presence: true

  def fetch_today_times
    today_times = nil

    availability.each do |date|
      today_times = date if date.include?(Time.now.strftime("%A"))
    end

    today_times
  end

  def parse_date(string_date)
    string_date.gsub(', ', ' –').split(': ')[1].split(' –')
  end

  def open?
    today_times = fetch_today_times

    return false if today_times.blank?
    return false if today_times.include?("Closed")
    return true if today_times.include?("24 hours")

    today_times.gsub!('– 12:00 AM', '– 11:59 PM') if today_times.include?('– 12:00 AM')

    opening1 = Chronic.parse("this #{parse_date(today_times).first}")
    closing1 = Chronic.parse("this #{parse_date(today_times).second}")
    opening2 = Chronic.parse("this #{parse_date(today_times).third} PM") if parse_date(today_times).count == 4
    closing2 = Chronic.parse("this #{parse_date(today_times).fourth}") if parse_date(today_times).count == 4

    if parse_date(today_times).count == 4
      (Time.now > opening1 && Time.now < closing1) || (Time.now > opening2 && Time.now < closing2)
    else
      Time.now > opening1 && Time.now < closing1
    end
  end

  def restaurant?
    types.each do |type|
      return true if type.include?('restaurant')
    end
  end

  def convenience_store?
    types.each do |type|
      return true if type.include?('convenience_store')
    end
  end

  def gas_station?
    types.each do |type|
      return true if type.include?('gas_station')
    end
  end
end
