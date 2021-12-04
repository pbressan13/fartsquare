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
      if parameters.select! { |_k, v| v } == {}
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
      else
        establishment.available_now = false
      end
    end

    @establishments = @establishments.sort_by { |establishment| establishment.available_now ? 0 : 1 }
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
end
