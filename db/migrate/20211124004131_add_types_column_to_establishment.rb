class AddTypesColumnToEstablishment < ActiveRecord::Migration[6.1]
  def change
    add_column :establishments, :types, :jsonb, default: '{}'
  end
end
