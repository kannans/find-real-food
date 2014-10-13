class CreateQualityRatings < ActiveRecord::Migration
  def change
    create_table :quality_ratings do |t|
      t.references :category
      t.string :name
      t.string :value

      t.timestamps
    end
    add_index :quality_ratings, :category_id
  end
end
