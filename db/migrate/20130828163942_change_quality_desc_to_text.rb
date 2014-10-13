class ChangeQualityDescToText < ActiveRecord::Migration
  def change
    change_column :quality_ratings, :value, :text
  end
end
