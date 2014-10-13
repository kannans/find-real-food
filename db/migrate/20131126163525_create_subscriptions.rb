class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.string     :subscription_type
      t.timestamp  :purchased_at
      t.timestamp  :expires_at
      t.timestamps
    end
  end
end
