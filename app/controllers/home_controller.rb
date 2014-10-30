class HomeController < ApplicationController
  def index
  	
  	if params[:zip]
  		zip = params[:zip]
      session[:zip] = zip
  	else
    	zip = '94123'
      session[:zip] = zip
  	end
    zip = '94123'
    
    search = ''
  	@location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
    
    if @location !=''
	  @products = Product.sort_by_rating(@location,search)
    @products_locations = Product.sort_by_rating(@location,search).collect{|c| c.location_id}.join(',')
    @locations = Location.where("id in (#{@products_locations})")
    else
    @locations = Location.near("#{zip}", 20)
    end

   	@sliders = Slider.all
   	
    
  end
end
