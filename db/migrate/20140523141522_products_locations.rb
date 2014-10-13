class ProductsLocations < ActiveRecord::Migration
  def change
    create_table :locations_products do |t|
      t.integer :product_id
      t.integer :location_id
      t.timestamps
    end
  end
end
