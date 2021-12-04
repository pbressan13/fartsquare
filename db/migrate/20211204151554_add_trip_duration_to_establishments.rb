class AddTripDurationToEstablishments < ActiveRecord::Migration[6.1]
  def change
    add_column :establishments, :trip_duration, :float
  end
end
