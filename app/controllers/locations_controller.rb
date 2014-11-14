class LocationsController < ApplicationController
  def index
  	@location = Location.find(params[:slug])
    @products = Product.search_products(@location.id).sortorder().first(20)
    @brands = Brand.search_brands(@location.id)
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
