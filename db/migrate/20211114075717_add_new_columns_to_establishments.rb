class AddNewColumnsToEstablishments < ActiveRecord::Migration[6.1]
  def change
    add_column :establishments, :full_address, :string
    add_column :establishments, :phone_number, :string
    add_column :establishments, :lat, :decimal
    add_column :establishments, :lng, :decimal
    add_column :establishments, :google_id, :string
    add_column :establishments, :availability, :jsonb, default: "{}"
    add_column :establishments, :business_status, :string
  end
end
