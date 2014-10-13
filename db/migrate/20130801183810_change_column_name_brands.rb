class ChangeColumnNameBrands < ActiveRecord::Migration
  def self.up
    rename_column :brands, :find_store_or_farmers_market, :store_or_farmers_market
  end

  def self.down
    rename_column :brands, :store_or_farmers_market, :find_store_or_farmers_market
  end
end
