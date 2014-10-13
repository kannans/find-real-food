class DropCoverImageTable < ActiveRecord::Migration
  def change
    drop_table :cover_images
  end
end
