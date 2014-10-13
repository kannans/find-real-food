class AddCoverPhotoToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :cover_photo
  end

  def self.down
    remove_attachment :users, :cover_photo
  end
end
