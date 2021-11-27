class BathroomsController < ApplicationController
  def destroy
    @bathroom.destroy
  end
end
