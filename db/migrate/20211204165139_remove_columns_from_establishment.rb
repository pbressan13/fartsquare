class RemoveColumnsFromEstablishment < ActiveRecord::Migration[6.1]
  def change
    remove_column :establishments, :avaliable_now?, :string
    remove_column :establishments, :available_now?, :string
  end
end
