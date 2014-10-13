class AddNewColumnsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :facebook_id
    end
  end
end
