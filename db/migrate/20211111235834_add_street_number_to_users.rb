class AddStreetNumberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :street_number, :integer
  end
end
