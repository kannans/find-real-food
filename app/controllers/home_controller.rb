class HomeController < ApplicationController
  def index
  	
  	
    zip = session[:zip]

    @current_page ='home';

  	@location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
    if @location !=''
       
  	  @products =  Product.search_products(@location).sortorder().first(20)
      
      @products_locations = Product.search_products(@location).sortorder().collect{|c| c.location_id}.join(',')
      if @products_locations!=''
      @locations = Location.where("id in (#{@products_locations})")
      end
    else
       
    @products = Product.search_products().sortorder().first(20)
    
    end

   	@sliders = Slider.first(4)
   	 
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
