ActiveAdmin.register Category do
  filter :title
  index do
    column :title
    column :created_at
    column :sort
    default_actions
  end

  form :partial => "form"

   
end
