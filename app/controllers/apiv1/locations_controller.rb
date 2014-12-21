class Apiv1::LocationsController < Apiv1::BaseController
  respond_to :json
  skip_filter :ensure_user_authentication!

  api :GET, '/locations', 'Get location count'
  def total_count
    lat = params[:lat]
    long = params[:long]
    location = Geocoder.search("#{lat}, #{long}")

    location.each do |lo|
      if lo.postal_code
        @zip_code = lo.postal_code
      end
    end

    total_count = Location.near("#{@zip_code}", 25).find(:all).count

    respond_to do |format|
      format.json {render :json => {:success => true, :locations=> {:total_count => total_count, :zip_code => @zip_code}}}
    end
  end

  api :GET, '/locations', 'List Locations'
  def index
    @zip_code = params[:zip_code]
    @type = params[:type]
    
    
    if params[:miles]
      @miles = params[:miles]
    else
      @miles = 25
    end
    if @type
      locations = Location.near("#{@zip_code}", @miles).where("location_type='#{@type}'").first(20)
    else
      locations = Location.near("#{@zip_code}", @miles).first(20)
    end
    
    
    respond_to do |format|
      format.json {render :json => {:success => true, :locations => locations}}
    end
  end

  api :GET, '/locations/:id', 'Get brand and product list based on location'
  def show
    location_id = params[:id]
    if params[:page]
      page = params[:page]
    else
      page = 1
    end
    @locations = Location.find(location_id)
    @brands = Brand.search_brands(location_id).paginate(page: page, per_page: 30)
    @products = Product.search_products(location_id).availabilityfilter('store').sortorder().paginate(page: page, per_page: 30)

    respond_to do |format|
      format.json {render :json => {:success => true, :brands => @brands, :products => @products, :location => @locations }}
    end
  end
end
