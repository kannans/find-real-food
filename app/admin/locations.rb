ActiveAdmin.register Location do
  filter :name
  filter :state
  filter :zip

  index do
    column :name
    column :address
    column :city
    column :state
    column :zip
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "Location" do
      f.input :name
      f.input :address
      f.input :city
      f.input :state
      f.input :zip
      f.input :hours
      f.input :phone
      f.input :website
      f.input :picture
      f.input :location_type, :as => :select, :collection => Location::TYPES

      f.input :parent, :collection => Location.parent_locations
    end
    f.actions
  end
end
