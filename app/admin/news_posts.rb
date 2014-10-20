ActiveAdmin.register NewsPost do
  filter :title
  filter :author
  index do
    column :title
    column :author
    column :created_at
    default_actions
  end

  form :partial => "form"

end
