class CreateFlagRequests < ActiveRecord::Migration
  def change
    create_table :flag_requests do |t|

      t.timestamps
    end
  end
end
