class AddStreetAddressToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :street_address, :string
  end
end
