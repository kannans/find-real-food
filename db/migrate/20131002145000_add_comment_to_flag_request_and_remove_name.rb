class AddCommentToFlagRequestAndRemoveName < ActiveRecord::Migration
  def change
    remove_column :flag_requests, :name
    add_column :flag_requests, :comment, :text
  end
end
