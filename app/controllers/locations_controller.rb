class LocationsController < ApplicationController
  def index
  	@location = Location.find(params[:slug])
  	if location !=''
		  @products = Product.sort_by_rating(@location.id,'')
	else
		  @products = Product.sort_by_rating()
	end
	@productsall = Product.sort_by_rating()

  end
end
