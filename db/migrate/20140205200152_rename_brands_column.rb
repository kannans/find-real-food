class RenameBrandsColumn < ActiveRecord::Migration
  def up
    rename_column :brands, :store_or_farmers_market, :store_farmers_market
  end

  def down
    rename_column :brands, :store_farmers_market, :store_or_farmers_market
  end
end
