class HomeController < ApplicationController
  def index
  	
  	if params[:zip]
  		zip = params[:zip]
      session[:zip] = zip
  	elsif session[:zip]
    	zip = session[:zip]
  	end
    
    
    @location = Location.near("#{zip}", 100).collect{|c| c.id}.join(',')
    @centerlocation = Location.near("#{zip}", 100).first
    if @location !=''
       
  	  @products =  Product.search_products(@location).sortorder().first(20)
      
      @products_locations = Product.search_products(@location).sortorder().collect{|c| c.location_id}.join(',')
      if @products_locations!=''
      @locations = Location.where("id in (#{@products_locations})")
      end
    else
       
    @products = Product.search_products().sortorder().first(20)
    
    end

   	@sliders = Slider.all
   	 
  end
 
  def setzip
    lati = params[:lat]
    longi = params[:long]
    location  = Geocoder.search("#{lati}, #{longi}")
    location.each do |lo|
      if lo.postal_code
      
        session[:zip] = lo.postal_code

      end
    end
  end


  def map
    location = params[:location]
    if location!=''
      @locations = Location.where("id in (#{location})")
    end
  end
end
