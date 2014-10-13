class CreateCmsTexts < ActiveRecord::Migration
  def change
    create_table :cms_texts do |t|
      t.string :key
      t.text   :value
      t.timestamps
    end
  end
end
