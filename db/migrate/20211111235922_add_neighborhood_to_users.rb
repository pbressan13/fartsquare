class AddNeighborhoodToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :neighborhood, :string
  end
end
