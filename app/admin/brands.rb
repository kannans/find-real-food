ActiveAdmin.register Brand do
	filter :name
  filter :approved, :as => :select

  collection_action :select_cities, method: :get do
    if params[:state]
      @cities = Location.where(:state => params[:state]).pluck(:city).uniq.reject(&:blank?).sort.each_with_index.map { |city,idx| [city,idx] }.insert(0, ['',''])
      puts "Location.where(:state => #{params[:state]}).pluck(:city).uniq.reject(&:blank?).sort.each_with_index.map { |city,idx| [city,idx] }.insert(0, ['',''])"
    else
      @cities = [['', '']]
    end
  end

  collection_action :select_zipcodes, method: :get do
    if params[:city]
      @zipcodes = Location.where(:state => params[:state], :city => params[:city]).pluck(:zip).uniq.reject(&:blank?).sort.each_with_index.map { |zip,idx| [zip,idx] }.insert(0, ['',''])
      puts @zipcodes
    else
      @zipcodes = [['', '']]
    end
  end
  
  collection_action :select_locations, method: :get do
    if params[:zipcode]
      @locations = Location.where(:state => params[:state], :city => params[:city], :zip => params[:zipcode]).pluck(:name).uniq.reject(&:blank?).sort.map { |location| [location, location]}
      @selected_locations = Location.where(:id => BrandsLocation.where(:brand_id => Brand.where(:slug => params[:brand]).pluck(:id).first).pluck(:location_id)).pluck(:name).uniq.reject(&:blank?).sort.map { |location| [location, location]}
      puts @locations
      puts "$$$$$$$$$$$$$$$$ all locations count: #{@locations.count}"      
      puts @selected_locations
      puts "$$$$$$$$$$$$$$$$ selected set count: #{@selected_locations.count}"
      puts "$$$$$$$$$$$$$$$$ brand: #{params[:brand]}"
      puts "Location.where(:state => #{params[:state]}, :city => #{params[:city]}, :zip => #{params[:zipcode]}).pluck(:name).uniq.reject(&:blank?).sort.map { |location| [location, location]}"
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
