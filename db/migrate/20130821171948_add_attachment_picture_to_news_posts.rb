class AddAttachmentPictureToNewsPosts < ActiveRecord::Migration
  def self.up
    change_table :news_posts do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :news_posts, :picture
  end
end
