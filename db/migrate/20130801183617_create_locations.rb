class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.references :state
      t.string :zip
      t.string :phone
      t.string :website
      t.string :hours

      t.timestamps
    end
    add_index :locations, :state_id
  end
end
