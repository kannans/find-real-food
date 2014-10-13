class SetDefaultForApprovedColumns < ActiveRecord::Migration
  def change
    change_column :brands, :approved, :boolean, :default => false
    change_column :products, :approved, :boolean, :default => false
  end
end
