class LocationsController < ApplicationController
  def index
  	@location = Location.find(params[:slug])
    puts "#{@location}"
  	if @location !=''
		  @products = Product.sort_by_rating(@location.id,'')
	else
		  @products = Product.sort_by_rating()
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
