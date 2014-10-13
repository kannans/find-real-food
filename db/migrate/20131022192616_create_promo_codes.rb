class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string  :code
      t.integer :user_id
      t.timestamp :redeemed_at
      t.timestamps
    end
  end
end
