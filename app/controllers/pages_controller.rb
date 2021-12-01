class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

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

  def search
    pp params
  end
end
