class AddAssociationsToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :product_id, :integer
    add_column :ratings, :brand_id, :integer
  end
end
