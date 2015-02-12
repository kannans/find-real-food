ActiveAdmin.register Product do
  filter :name
  filter :available
  filter :brand
  filter :approved, :as => :select
  filter :category, :as => :select

  belongs_to :brand, :optional => true

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
      product_id = Product.where(:slug => params[:product]).pluck(:id)
      productlocs_locs_ids = LocationsProduct.where(:product_id => product_id).pluck(:location_id)
      filtered_locs = Location.where(:state => params[:state], :city => params[:city], :zip => params[:zipcode]).map { |loc| [loc.name, loc.id] }
      selected_locs = Location.where(:id => productlocs_locs_ids)
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
    default_actions
  end

  form :partial => "form"

  collection_action :list_ratings, :method => :get do
    params[:category_id]
    @data_for_select2 = QualityRating.where(:category_id => params[:category_id]).all
    render :json => @data_for_select2.map{|c| [c.id, c.name]}
  end
end
