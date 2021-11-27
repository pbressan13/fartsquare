class RenameLatlonToLatitudelongitude < ActiveRecord::Migration[6.1]
  def change
    rename_column :establishments, :lat, :latitude
    rename_column :establishments, :lng, :longitude
  end
end
