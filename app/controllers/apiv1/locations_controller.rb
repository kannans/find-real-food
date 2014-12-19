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

    total_count = Location.near("#{@zip_code}", 100).find(:all).count

    respond_to do |format|
      format.json {render :json => {:success => true, :total_count => total_count, :zip_code => @zip_code}}
    end
  end

  api :GET, '/locations', 'List Locations'
  def index
    @zip_code = params[:zip_code]
    locations = Location.near("#{@zip_code}", 100).find(:all)
    
    respond_to do |format|
      format.json {render :json => {:success => true, :locations => locations}}
    end
  end

  api :GET, '/locations/', 'get brand and product list'
  def show
    @locationid = params[:id]
    if params[:page]
          page = params[:page]
      else
          page = 1
      end

    @brands = Brand.search_brands(@locationid).paginate(page: page, per_page: 30)
    @products = Product.search_products(@locationid).availabilityfilter('store').sortorder().paginate(page: page, per_page: 30)
    
    respond_to do |format|
      format.json {render :json => {:success => true, :brands => @brands, :products => @products}}
    end
  end

end
