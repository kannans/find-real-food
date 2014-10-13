ActiveAdmin.register Brand do
	filter :name
  filter :approved, :as => :select

	index do
    column :name
    column :created_at
    column :updated_at
    column "Products" do |brand|
      link_to "#{brand.name} Products", admin_brand_products_path(brand)
    end
    default_actions
  end

  form :partial => "form"


end
