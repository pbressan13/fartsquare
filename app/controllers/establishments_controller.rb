class EstablishmentsController < ApplicationController
  before_action :find_establishment, only: %i[show edit update destroy]
  def show
  end

  def index
    @establishments = policy_scope(Establishment).order(created_at: :desc)
  end

  def new
    @establishment = Establishment.new
    authorize @establishment
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user
    # @establishment.available_at = parse_list
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

  # def parse_list
  #  days_in_list = ""
  #  params[:establishment][:available_at].each { |day| days_in_list += "#{day} " }
  #  days_in_list.strip.gsub(" ", ", ")
  # end

  def map
    @establishments = Establishment.all
    @geojson = []

    @establishments.each do |establishment|
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [establishment.longitude, establishment.latitude]
        },
        properties: {
          title: establishment.name,
          address: establishment.full_address,
          image: establishment.photo_link,
          id: establishment.id,
          'marker-color': '#00607d',
          'marker-symbol': 'circle',
          'marker-size': 'medium'
        }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: @geojson }  # respond with the created JSON object
    end
  end

  private

  def find_establishment
    @establishment = Establishment.find(params[:id])
  end

  def establishment_params
    params.require(:establishment).permit(:street_address,
                                          :street_number,
                                          :zipcode,
                                          :street_addon,
                                          :neighborhood,
                                          :city,
                                          :federal_unity,
                                          :establishment_name,
                                          images: [])
  end
end
