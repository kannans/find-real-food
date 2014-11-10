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
    if user_signed_in?
	  @products =  Product.search_products().sortorder().first(20)
    else
    @products =  Product.search_products().sortorder().first(12)     
    end
    @products_locations = Product.search_products(@location).sortorder().collect{|c| c.location_id}.join(',')
    if @products_locations!=''
    @locations = Location.where("id in (#{@products_locations})")
    end
    else
    @locations = Location.near("#{zip}", 20)
    if user_signed_in?
      @products = Product.search_products().sortorder().first(20)
    else
      @products = Product.search_products().sortorder().first(12)
    end
    end

   	@sliders = Slider.all
   	
    
  end
 

  def map
    location = params[:location]
    if location!=''
      @locations = Location.where("id in (#{location})")
    end
  end
end
