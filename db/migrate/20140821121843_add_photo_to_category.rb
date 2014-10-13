class AddPhotoToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :picture_file_name, :string
    add_column :categories, :picture_content_type, :string
    add_column :categories, :picture_file_size, :integer
    add_column :categories, :picture_updated_at, :datetime
  end
end
