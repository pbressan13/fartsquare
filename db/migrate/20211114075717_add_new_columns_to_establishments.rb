class AddNewColumnsToEstablishments < ActiveRecord::Migration[6.1]
  def change
    add_column :establishments, :full_address, :string
    add_column :establishments, :phone_number, :string
    add_column :establishments, :lat, :float
    add_column :establishments, :lng, :float
    add_column :establishments, :google_id, :string
    add_column :establishments, :business_status, :string
    add_column :establishments, :photo_link, :string
    add_column :establishments, :availability, :jsonb, default: '{}'
  end
end
