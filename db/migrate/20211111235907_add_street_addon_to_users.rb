class AddStreetAddonToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :street_addon, :string
  end
end
