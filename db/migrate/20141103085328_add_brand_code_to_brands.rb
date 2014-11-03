class AddBrandCodeToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :brand_code, :string
  end
end
