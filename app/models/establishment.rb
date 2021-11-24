class Establishment < ApplicationRecord
  belongs_to :user
  has_one :bathroom, dependent: :destroy
  has_many_attached :images
  serialize :availability
  serialize :types

  def parse_date(string_date)
    string_date.split(': ')[1].split(' –')
  end

  def fetch_today_times
    today_times = nil

    self.availability.each do |date|
      today_times = date if date.include?(Time.now.strftime('%A'))
    end

    today_times
  end

  def open?
    today_times = fetch_today_times

    if today_times.blank? || today_times.include?('Closed')
      false
    elsif today_times.include?('24 hours')
      true
    else
      opening = Chronic.parse("this #{parse_date(today_times).first}")
      closing = Chronic.parse("this #{parse_date(today_times).last}")
      Time.now > opening && Time.now < closing
    end
  end

  def restaurant?
    self.types.each do |type|
      return true if type.include?('restaurant')
    end
  end

  def convenience_store?
    self.types.each do |type|
      return true if type.include?('convenience_store')
    end
  end

  def gas_station?
    self.types.each do |type|
      return true if type.include?('gas_station')
    end
  end
end
