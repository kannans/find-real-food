class HomeController < ApplicationController
  def index
  	
  	if params[:zip]
  		zip = params[:zip]
      session[:zip] = zip
  	elsif session[:zip]
      zip = session[:zip]
  	else
    	zip = '94123'
      session[:zip] = zip
  	end

    
    search = ''
  	@location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
    
    if @location !=''
	  @products = Product.sort_by_rating(@location,search)
    end

   	@sliders = Slider.all
   	@locations = Location.near("#{zip}", 20)
    
  end
end
