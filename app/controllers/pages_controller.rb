class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  after_action :populate_db, only: [:home]

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
    UpdateEstablishmentJob.perform_async(current_user.id)
  end

  def fetch_position
    current_user.longitude = params[:data_coordinates].first.to_f
    current_user.latitude = params[:data_coordinates].second.to_f
    current_user.save!
  end
end
