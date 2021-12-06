class UpdateEstablishmentJob
  # queue_as :default
  include Sidekiq::Worker

  def perform(current_user)
    establishments = Establishment.all
    establishments.map do |establishment|
      unless establishment.trip_duration.present?
        if establishment.open?
          establishment.available_now = true
          establishment.trip_duration = duration_from_current_user2(establishment.google_id, current_user)
        else
          establishment.available_now = false
          establishment.trip_duration = 24 * 60 * 60
        end
        establishment.save!
      end
    end
  end

  def duration_from_current_user(longitude, latitude, current_user)
    url = "https://api.mapbox.com/directions/v5/mapbox/driving/#{current_user.longitude}%2C#{current_user.latitude}%3B#{longitude}%2C#{latitude}?alternatives=false&annotations=distance%2Cduration&continue_straight=false&geometries=geojson&overview=full&steps=false&access_token=#{ENV['MAPBOX_API_KEY']}"
    read_url = URI.parse(url).read
    request = JSON.parse(read_url).deep_symbolize_keys!
    request[:routes].first[:duration]
  end

  def duration_from_current_user2(google_id, current_user)
    url = URI("https://maps.googleapis.com/maps/api/directions/json?departure_time=now&destination=place_id:#{google_id}&origin=#{current_user.latitude},#{current_user.longitude}&region=br&language=pt-BR&key=#{ENV['PLACES_API']}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    data = JSON.parse(response.read_body).deep_symbolize_keys!
    data[:routes].first[:legs].first[:duration]
  end
end
