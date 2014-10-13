ActiveAdmin.register User do
  index do
    column :id
    column :name
    column :email
    default_actions
  end

  filter :email
  filter :name
  filter :city
  filter :state
  
  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :name
      f.input :city
      f.input :state
      f.input :bio
      f.input :private
      f.input :pro_account
    end
    f.actions
  end
end
