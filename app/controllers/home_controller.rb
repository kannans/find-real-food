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
	  @products = Product.sort_by_rating('',search)
    @products_locations = Product.sort_by_rating(@location,search).collect{|c| c.location_id}.join(',')
    if @products_locations!=''
    @locations = Location.where("id in (#{@products_locations})")
    end
    else
    @locations = Location.near("#{zip}", 20)
    @products = Product.sort_by_rating('',search)
    end

   	@sliders = Slider.all
   	
    
  end

  def map
    location = params[:location]
    @locations = Location.where("id in (#{location})")
  end
end
