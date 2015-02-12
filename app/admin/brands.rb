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
      @zipcodes = zips.uniq.reject(&:blank?).sort.map { |zip| [zip,zip] }.insert(0, ['',''])
    else
      @zipcodes = [['', '']]
    end
  end
  
  collection_action :select_locations, method: :get do
    if params[:zipcode]
      brand_id = Brand.where(:slug => params[:brand]).pluck(:id)
      brandlocs_locs_ids = BrandsLocation.where(:brand_id => brand_id).pluck(:location_id)
      filtered_locs = Location.where(:state => params[:state], :city => params[:city], :zip => params[:zipcode]).map { |loc| [loc.name, loc.id] }
      selected_locs = Location.where(:id => brandlocs_locs_ids)
      selected_locs_map = selected_locs.map { |loc| [loc.name, loc.id] }

      locations_set = filtered_locs+selected_locs_map
      @locations = locations_set.uniq
      
      selected_locs_ids = selected_locs.pluck(:id)
      @selected_locations = @locations.each.map { |loc| loc[1] if selected_locs_ids.include? (loc[1]) }.compact
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
