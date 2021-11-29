class AddFieldToEstablishment < ActiveRecord::Migration[6.1]
  def change
    add_column :establishments, :available_now, :boolean
  end
end
