class AddStateToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :state, :string
    add_column :locations, :location_code, :string
  end
end
