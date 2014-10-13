class BrandsLocations < ActiveRecord::Migration
  def change
    create_table :brands_locations do |t|
      t.integer :brand_id
      t.integer :location_id
      t.timestamps
    end
  end
end
