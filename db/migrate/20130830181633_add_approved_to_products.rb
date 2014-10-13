class AddApprovedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :approved, :boolean
  end
end
