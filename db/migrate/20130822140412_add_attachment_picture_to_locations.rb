class AddAttachmentPictureToLocations < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :locations, :picture
  end
end
