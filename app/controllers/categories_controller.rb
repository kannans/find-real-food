class CategoriesController < ApplicationController

	def index

		@categories = Category.paginate(page: params[:page], per_page: 5).order('sort ASC')

	end

	def products
		
		if params[:zip]
	  		zip = params[:zip]
	      session[:zip] = zip
	  	elsif session[:zip]
	      zip = session[:zip]
	  	end

	  	 if params[:page]
      		page = params[:page]
    	else
      		page = 1
    	end

	    @category = Category.find(params[:slug])
	    
	  	@location = Location.near("#{zip}", 10).collect{|c| c.id}.join(',')
	  	@centerlocation = Location.near("#{zip}", 10).first
	    
	  	@current_page ='category';
	    if @location !=''
	    	
		  	@productsnear = Product.search_products(@location).categoryfilter(@category.id).sortorder().paginate(page: page, per_page: 30)
		  	@products_locations =  Product.search_products(@location).categoryfilter(@category.id).collect{|c| c.location_id}.join(',')
			
			if @products_locations!=''
		       @locations = Location.where("id in (#{@products_locations})") 
		  	end
	    end
		   	
		   	@products = Product.search_products().categoryfilter(@category.id).sortorder().paginate(page: page, per_page: 30)
		   	@brand_ids = Product.search_products().categoryfilter(@category.id).collect{|b| b.brand_id}.join(',')
			@brands = Brand.where("id in (#{@brand_ids})").paginate(page: page, per_page: 30)
	    

	end


end
