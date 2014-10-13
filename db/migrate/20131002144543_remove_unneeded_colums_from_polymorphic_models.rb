class RemoveUnneededColumsFromPolymorphicModels < ActiveRecord::Migration
  def change
    remove_column :ratings, :brand_id
    remove_column :ratings, :product_id

    remove_column :flag_requests, :brand_id
    remove_column :flag_requests, :product_id
  end
end
