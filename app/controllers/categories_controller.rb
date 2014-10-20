class CategoriesController < ApplicationController

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

	  	@locations = Location.near("#{zip}", 20)
		@categories = Category.paginate(page: params[:page], per_page: 5).order('title DESC')

	end

	def products
		
		if params[:zip]
	  		zip = params[:zip]
	      session[:zip] = zip
	  	elsif session[:zip]
	      zip = session[:zip]
	  	else
	    	zip = '94123'
	      session[:zip] = zip
	  	end

	    category = Category.find(params[:slug])
	    search = ''
	  	@location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
	    
	    if @location !=''
		  @products = Product.sort_by_rating(@location,search,category)
		  @products_locations = Product.sort_by_rating(location,search,category).collect{|c| c.location_id}.join(',')
	    end

	   	@sliders = Slider.all
	   	@locations = Location.near("#{zip}", 20)

		
		#@products = Product.where(category_id: category.id)
		@brands = Brand.all
	end


end
