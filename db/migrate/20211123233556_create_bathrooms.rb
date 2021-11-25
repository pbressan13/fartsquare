class CreateBathrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :bathrooms do |t|
      t.references :establishment, null: false, foreign_key: true
      t.boolean :tomada
      t.boolean :papel_premium
      t.boolean :chuveirinho
      t.boolean :internet
      t.timestamps
    end
  end
end
