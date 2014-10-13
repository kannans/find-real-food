class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_key
      t.references :category
      t.references :brand
      t.string :name
      t.references :quality_rating
      t.boolean :in_stores
      t.boolean :available
      t.string :not_available

      t.timestamps
    end
    add_index :products, :category_id
    add_index :products, :brand_id
    add_index :products, :quality_rating_id
  end
end
