class CreateFovorites < ActiveRecord::Migration
  def change
    create_table :fovorites do |t|
      t.integer :user_id
      t.string :type
      t.integer :reference_id

      t.timestamps
    end
  end
end
