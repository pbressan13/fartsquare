require 'json'
require 'open-uri'

class EstablishmentsController < ApplicationController
  before_action :find_establishment, only: %i[show edit update destroy]

  def show
  end

  def filtered_establishments
    if params[:filter].nil?
      policy_scope(Establishment).where(business_status: "OPERATIONAL")
    else
      parameters = params.require(:filter).permit(:tomada, :internet, :chuveirinho, :papel_premium).to_h.symbolize_keys
      parameters.transform_values! { |v| ActiveModel::Type::Boolean.new.cast(v) }
      if parameters.select! { |_k, v| v }.blank?
        policy_scope(Establishment).where(business_status: "OPERATIONAL")
      else
        policy_scope(Establishment).joins(:bathroom).where(business_status: "OPERATIONAL", bathroom: parameters)
      end
    end
  end

  def index
    @establishments = filtered_establishments

    @establishments.map do |establishment|
      if establishment.open?
        establishment.available_now = true
        establishment.trip_duration = duration_from_current_user(establishment.longitude, establishment.latitude)
      else
        establishment.available_now = false
        establishment.trip_duration = 24 * 60 * 60
      end
    end

    @establishments = @establishments.sort_by(&:trip_duration)
  end

  def new
    @establishment = Establishment.new
    authorize @establishment
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user
    if @establishment.save
      redirect_to establishment_path(@establishment)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @establishment.update(establishment_params)
    @establishment.user = current_user
    # @establishment.available_at = parse_list
    if @establishment.save
      redirect_to establishment_path(@establishment)
    else
      render :new
    end
  end

  def destroy
    @establishment.destroy

    redirect_to establishments_path
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

  private

  def find_establishment
    @establishment = Establishment.find(params[:id])
  end

  def establishment_params
    params.require(:establishment).permit(
      :full_address, :street_number, :zipcode, :street_addon,
      :neighborhood, :city, :federal_unity, :establishment_name,
      images: []
    )
  end

  def get_position(position)
    @coordinates = position
  end
end
