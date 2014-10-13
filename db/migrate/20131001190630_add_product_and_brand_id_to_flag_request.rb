class AddProductAndBrandIdToFlagRequest < ActiveRecord::Migration
  def change
    add_column :flag_requests, :product_id, :integer
    add_column :flag_requests, :brand_id, :integer
  end
end
