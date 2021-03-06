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
      @type = params[:type].gsub("'", "\\\\'")
      @locations = Location.where("location_type like '%#{@type}%'").near("#{@zip_code}", @miles).first(20)
    else
      @locations = Location.near("#{@zip_code}", @miles).first(20)
    end
    
    
    respond_to do |format|
      #format.json {render :json => {:success => true, :locations => @locations}}
      format.json { render_for_api :locationlist, :json => @locations, :meta => { :success => true} }
    end
  end

  api :GET, '/locations/:id', 'Get brand and product list based on location'
  def show
    search_result_limit = 20
    location_id = params[:id]
    if params[:page]
      page = params[:page]
    else
      page = 1
    end
    @resources = {}
    @resources[:location] = Location.where("id=#{location_id}").select("locations.*, '1' as distance")
    @resources[:brands] = Brand.search_brands(location_id)
    @resources[:products] = Product.search_products(location_id)
    
    
    @search = Search.new({
      :products => @resources[:products],
      :brands => @resources[:brands],
      :locations => @resources[:location]
      })

    respond_to do |format|
      format.json { render_for_api :search, :json => @search, :meta => { :success => true} }
    end

    #respond_to do |format|
    #  format.json {render :json => {:success => true, :Details => {:brands => @resources[:brands], :products => @resources[:products], :location => [@resources[:location] ] }}}
    #end
  end
end
