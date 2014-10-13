class AddSlugToNewsPosts < ActiveRecord::Migration
  def change
    add_column :news_posts, :slug, :string
    add_index :news_posts, :slug, unique: true
  end
end
