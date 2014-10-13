class CreateNewsPosts < ActiveRecord::Migration
  def change
    create_table :news_posts do |t|
      t.string :title
      t.string :author
      t.string :website
      t.text :body
      t.binary :image

      t.timestamps
    end
  end
end
