class AddCoverImagesTable < ActiveRecord::Migration
  def change
    create_table :cover_images do |t|
      t.string  :name
      t.integer :imageable_id
      t.string  :imageable_type
      t.timestamps
    end
  end
end
