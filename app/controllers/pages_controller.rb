class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @establishments = Establishment.all
    @markers = @establishments.geocoded.map do |establishment|
      {
        latitude: establishment.latitude,
        longitude: establishment.longitude
      }
    end
  end
end
