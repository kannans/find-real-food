class AddFlaggableToFlagRequest < ActiveRecord::Migration
  def change
    add_column :flag_requests, :name, :string
    add_column :flag_requests, :flaggable_id, :integer
    add_index :flag_requests, :flaggable_id
    add_column :flag_requests, :flaggable_type, :string
  end
end
