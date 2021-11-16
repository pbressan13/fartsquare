class RemoveColumnsFromEstablishments < ActiveRecord::Migration[6.1]
  def change
    remove_column :establishments, :street_address, :string
    remove_column :establishments, :street_number, :string
    remove_column :establishments, :zipcode, :string
    remove_column :establishments, :street_addon, :string
    remove_column :establishments, :neighborhood, :string
  end
end
