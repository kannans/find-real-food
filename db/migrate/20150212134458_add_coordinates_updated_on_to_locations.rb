class AddCoordinatesUpdatedOnToLocations < ActiveRecord::Migration
  def change
  	add_column :locations, :coordinates_updated_on, :datetime
  end
end
