ActiveAdmin.register Brand do
	filter :name
  filter :approved, :as => :select

  collection_action :select_cities, method: :get do
    if params[:state]
      @cities = Location.where(:state => params[:state]).pluck(:city).uniq.reject(&:blank?).sort.each_with_index.map { |city,idx| [city, idx] }.insert(0, ['',''])   
    else
      @cities = [['', '']]
    end
  end

  collection_action :select_zipcodes, method: :get do
    if params[:city]
      zips = Location.where(:state => params[:state], :city => params[:city]).pluck(:zip)
      @zipcodes = zips.uniq.reject(&:blank?).sort.each_with_index.map { |zip,idx| [zip,idx] }.insert(0, ['',''])
    else
      @zipcodes = [['', '']]
    end
  end
  
  collection_action :select_locations, method: :get do
    if params[:zipcode]
      locs = Location.where(:state => params[:state], :city => params[:city], :zip => params[:zipcode])
      @locations = locs.pluck(:name).uniq.reject(&:blank?).sort.each_with_index.map { |location,idx| [location, idx] }
      brand_id = Brand.where(:slug => params[:brand]).pluck(:id)
      locs_ids = locs.pluck(:id).uniq.reject(&:blank?)
      brand_locs = BrandsLocation.where(:brand_id => brand_id, :location_id => locs_ids).pluck(:location_id).uniq.reject(&:blank?)
      brand_locs_names = locs.where(:id => brand_locs).pluck(:name).uniq.reject(&:blank?)
      @selected_locations = @locations.each.map { |loc| loc[1] if brand_locs_names.include? (loc[0]) }.compact
    else
      @locations = [['', '']]
    end
  end

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
