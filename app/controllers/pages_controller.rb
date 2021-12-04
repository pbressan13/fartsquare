class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  skip_after_action :populate_db, only: [:home]

  def home
    @establishments = Establishment.all
    @markers = @establishments.geocoded.map do |establishment|
      {
        latitude: establishment.latitude,
        longitude: establishment.longitude,
        name: establishment.name,
        full_address: establishment.full_address,
        image_url: helpers.asset_url(establishment.photo_link || "vaso.png")
      }
    end
  end

  def populate_db
    @establishments = Establishment.all

    @establishments.map do |establishment|
      unless establishment.trip_duration.present?
        if establishment.open?
          establishment.available_now = true
          establishment.trip_duration = duration_from_current_user(establishment.longitude, establishment.latitude)
        else
          establishment.available_now = false
          establishment.trip_duration = 24 * 60 * 60
        end
        establishment.save!
      end
    end
  end

  def fetch_position
    current_user.longitude = params[:data_coordinates].first.to_f
    current_user.latitude = params[:data_coordinates].second.to_f
    current_user.save!
  end

  def duration_from_current_user(longitude, latitude)
    url = "https://api.mapbox.com/directions/v5/mapbox/driving/#{current_user.longitude}%2C#{current_user.latitude}%3B#{longitude}%2C#{latitude}?alternatives=false&annotations=distance%2Cduration&continue_straight=false&geometries=geojson&overview=full&steps=false&access_token=#{ENV['MAPBOX_API_KEY']}"
    read_url = URI.parse(url).read
    request = JSON.parse(read_url).deep_symbolize_keys!
    request[:routes].first[:duration]
  end
end
