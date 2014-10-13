ActiveAdmin.register Faq do
  menu :label => "FAQs"
  
  filter :title
  index do
    column :title
    column :answer
    default_actions
  end

  form :partial => "form"

   
end
