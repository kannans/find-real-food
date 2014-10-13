class AddStoreLocatorUrlToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :store_locator_url, :string
  end
end
