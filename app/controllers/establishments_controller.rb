class EstablishmentsController < ApplicationController
  before_action :find_establishment, only: %i[show edit update destroy]
  def show
  end

  def index
    @establishments = Establishment.all
  end

  def new
    @establishment = Establishment.new
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.available_at = parse_list
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
    @establishment.available_at = parse_list
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

  def parse_list
    days_in_list = ""
    params[:establishment][:available_at].each { |day| days_in_list += "#{day} " }
    days_in_list.strip.gsub(" ", ", ")
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
                                          :available_at,
                                          images: [])
  end
end
