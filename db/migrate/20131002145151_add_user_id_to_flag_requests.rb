class AddUserIdToFlagRequests < ActiveRecord::Migration
  def change
    add_column :flag_requests, :user_id, :integer
  end
end
