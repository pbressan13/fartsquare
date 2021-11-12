class AddFederalUnityToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :federal_unity, :string
  end
end
