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
    locations = Location.near("#{@zip_code}", 100).first(20)
    
    respond_to do |format|
      format.json {render :json => {:success => true, :locations => locations}}
    end
  end
 
end
