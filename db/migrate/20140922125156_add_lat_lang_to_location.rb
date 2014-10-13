class AddLatLangToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :latitude, :string
    add_column :locations, :latitudengitude, :string
  end
end
