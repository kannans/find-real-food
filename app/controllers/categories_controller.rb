class CategoriesController < ApplicationController

	def index
		@categories = Category.paginate(page: params[:page], per_page: 5).order('title DESC')

	end

	def products
		
		if params[:zip]
	  		zip = params[:zip]
	      session[:user] = zip
	  	elsif session[:user]
	      zip = session[:user]
	  	else
	    	zip = '94123'
	      session[:user] = zip
	  	end

	    category = Category.find(params[:slug])
	    search = ''
	  	location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
	    
	    if location !=''
		  @products = Product.sort_by_rating(location,search,category)
	    end

	   	@sliders = Slider.all
	   	@locations = Location.near("#{zip}", 20)

		
		#@products = Product.where(category_id: category.id)
		@brands = Brand.all
	end


end
