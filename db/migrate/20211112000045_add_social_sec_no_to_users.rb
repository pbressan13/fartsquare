class AddSocialSecNoToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :social_sec_no, :string
  end
end
