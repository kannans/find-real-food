class AddApprovedToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :approved, :boolean
  end
end
