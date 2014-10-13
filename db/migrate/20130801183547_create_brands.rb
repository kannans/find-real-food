class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :phone
      t.string :website
      t.boolean :order_by_phone
      t.boolean :order_by_online
      t.boolean :find_store_or_farmers_market
      t.boolean :third_party_available

      t.timestamps
    end
  end
end
