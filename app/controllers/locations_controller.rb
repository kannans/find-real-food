class LocationsController < ApplicationController
  def index
  	@location = Location.find(params[:slug])
    
  	if @location !=''
      if user_signed_in?
		  @products = Product.search_products(@location.id).sortorder().first(20)
     else
      @products = Product.search_products(@location.id).sortorder().first(12)
     end
	else
     if user_signed_in?
		  @products = Product.search_products().sortorder().first(20)
     else
      @products = Product.search_products().sortorder().first(12)
     end
	end
	#@productsall = Product.sort_by_rating()
  @brands = Brand.search_by_locations_and_name(@location.id,'')

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
