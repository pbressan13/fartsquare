class RenameColumnsOnEstablishments < ActiveRecord::Migration[6.1]
  def change
    rename_column :establishments, :establishment_name, :name
  end
end
