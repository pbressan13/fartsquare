class CreateEstablishments < ActiveRecord::Migration[6.1]
  def change
    create_table :establishments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :street_address
      t.integer :street_number
      t.string :zipcode
      t.string :street_addon
      t.string :neighborhood
      t.string :city
      t.string :federal_unity
      t.string :establishment_name
      t.string :available_at

      t.timestamps
    end
  end
end
