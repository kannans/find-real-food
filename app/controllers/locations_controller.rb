class LocationsController < ApplicationController
  def index
      
      if params[:page]
          page = params[:page]
      else
          page = 1
      end

  	@location = Location.find(params[:slug])
    
    @products = Product.search_products(@location.id).sortorder().paginate(page: page, per_page: 30)
    @brands = Brand.search_brands(@location.id).paginate(page: page, per_page: 30)
  end

  def create
  	@location = Location.new(params[:location])
        if @location.save
    	  redirect_to @location, notice: "Successfully created."
        else
       	  render :action => 'edit'
		end

  end
end
