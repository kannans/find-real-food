class CategoriesController < ApplicationController

	def index

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

	    @category = Category.find(params[:slug])
	    search = ''
	  	@location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
	    
	    if @location !=''
		  @products = Product.sort_by_rating(@location,search,@category)
		  @products_locations = Product.sort_by_rating(@location,search,@category).collect{|c| c.location_id}.join(',')
		  @brand_ids = Product.sort_by_rating(@location,search,@category).collect{|c| c.brand_id}.join(',')
		  @brands = Brand.where("id in (#{@brand_ids})")
		  if @products_locations!=''
	      @locations = Location.where("id in (#{@products_locations})")
	  	  end
	    else
	   	  @locations = Location.near("#{zip}", 20)
	    end

	   	@sliders = Slider.all
	   	
		
		#@products = Product.where(category_id: category.id)
		
	end


end
