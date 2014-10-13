ActiveAdmin.register Feedback do
  index do
    column :subject
    column :message
    column :user
  end

  form do |f|
    f.inputs "Feedback" do
      f.input :user
      f.input :subject
      f.input :message
    end
    f.actions
  end

end
