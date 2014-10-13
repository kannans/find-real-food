class AddUserIdToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :user_id, :integer
  end
end
