ActiveAdmin.register Page do
  menu :label => "CMS Pages"
  
  filter :title
  index do
    column :title
    default_actions
  end

  form :partial => "form"

   
end
