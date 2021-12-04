class RemoveAddressFieldsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :street_number, :number
    remove_column :users, :zipcode, :string
    remove_column :users, :street_addon, :string
    remove_column :users, :neighborhood, :string
    remove_column :users, :city, :string
  end
end
