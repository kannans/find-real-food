class AddProFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pro_account, :boolean, :default => false
  end
end
