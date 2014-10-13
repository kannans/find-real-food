ActiveAdmin.register NewsPost do
  filter :title
  filter :author
  index do
    column :title
    column :author
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "NewsPost" do
      f.input :title
      f.input :author
      f.input :website
      f.input :body
      f.input :picture
    end
    f.actions
  end
end
