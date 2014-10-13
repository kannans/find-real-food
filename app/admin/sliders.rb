ActiveAdmin.register Slider do
  menu :label => "Sliders"
  
  filter :title
  index do
    column :title
    column :url
    default_actions
  end

  form :partial => "form"

   
end
