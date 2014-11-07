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
	  @products =  Product.search_products().sortorder().first(20)
    @products_locations = Product.search_products(@location).sortorder().collect{|c| c.location_id}.join(',')
    if @products_locations!=''
    @locations = Location.where("id in (#{@products_locations})")
    end
    else
    @locations = Location.near("#{zip}", 20)
    @products = Product.search_products().sortorder().first(20)
    end

   	@sliders = Slider.all
   	
    
  end

  def self.numofrows
     if session.session_id
     return 20 
    else
      return 2
    end
  end

  def map
    location = params[:location]
    @locations = Location.where("id in (#{location})")
  end
end
