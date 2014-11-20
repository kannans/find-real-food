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

     

     
    
    @locationval = Location.near("[37.09024, -95.712891]", 20).collect{|c| c.id}.join(',')

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
 

  def map
    location = params[:location]
    if location!=''
      @locations = Location.where("id in (#{location})")
    end
  end
end
