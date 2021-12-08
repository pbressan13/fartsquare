class UpdateEstablishmentJob
  # queue_as :default
  include Sidekiq::Worker

  def duration_from_current_user(longitude, latitude, id)
    user = User.find(id)
    p user
    url = "https://api.mapbox.com/directions/v5/mapbox/driving/#{user.longitude}%2C#{user.latitude}%3B#{longitude}%2C#{latitude}?alternatives=false&annotations=distance%2Cduration&continue_straight=false&geometries=geojson&overview=full&steps=false&access_token=#{ENV['MAPBOX_API_KEY']}"
    read_url = URI.parse(url).read
    request = JSON.parse(read_url).deep_symbolize_keys!
    request[:routes].first[:duration]
  end

  def perform(id)
    establishments = Establishment.all
    establishments.map do |establishment|
      if establishment.open?
        establishment.available_now = true
        establishment.trip_duration = duration_from_current_user(establishment.longitude, establishment.latitude, id)
      else
        establishment.available_now = false
        establishment.trip_duration = 24 * 60 * 60
      end
      establishment.save!
    end
  end
end
