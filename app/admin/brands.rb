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
      @locations = locs.map { |loc| [loc.name, loc.id] }
      brand_id = Brand.where(:slug => params[:brand]).pluck(:id)
      locs_ids = locs.pluck(:id)
      brand_locs = BrandsLocation.where(:brand_id => brand_id, :location_id => locs_ids).pluck(:location_id)
      brand_locs_ids = locs.where(:id => brand_locs).pluck(:id)
      @selected_locations = @locations.each.map { |loc| loc[1] if brand_locs_ids.include? (loc[1]) }.compact
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
