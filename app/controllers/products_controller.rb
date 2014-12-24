class ProductsController < ApplicationController

def index
	q=
	@products = Product.sort_by_rating(q)
	@brands = Brand.all
	
end

def more_details
	
	if user_signed_in?
		if session[:zip]
			zip = session[:zip]
			@location = Location.near("#{zip}", 100).collect{|c| c.id}.join(',')
			@locations = Location.near("#{zip}", 100)
			@centerlocation = Location.near("#{zip}", 100).first
		end
		@product = Product.find(params[:slug])
    	#@locations = Location.where("locations.id IN (select location_id from locations_products where product_id=#{@product.id} limit 20 ) ")
		if @location
			@similar_product  = Product.where('id !=@product.id').search_products(@location).categoryfilter(@product.category_id).sortorder().first(20)
    	end
	else
		redirect_to "/login"
	end
	
end

def add_to_favorites
	
	@already_exists = Fovorite.where(user_id:current_user.id).where(reference_id: params[:product_id]).where(type: "Product").count
	if @already_exists < 1
	@favorite = Fovorite.create(user_id:current_user.id, type: "Product", reference_id: params[:product_id])
	@favorite.save
 	end
     
end

def add_comments
	
	@already_exists = Rating.where(user_id:current_user.id).where(ratable_id: params[:ratable_id]).where(ratable_type: "Product").count
	if @already_exists < 1
	@comment = Rating.create(user_id:current_user.id, ratable_type: "Product", ratable_id: params[:ratable_id], comment: params[:comment],  rating: params[:rating] )
	@comment.save
 	end
     
end

def add_flag

	@flag = FlagRequest.create(user_id:current_user.id, flaggable_type: "Product", flaggable_id: params[:product_id], comment: params[:comment] )
	@flag.save

end

def comments
	
	@ratings = Rating.where(ratable_id: params[:ratable_id]).where(ratable_type: "Product").paginate(page: params[:page], per_page: 3).order("id desc")

end

end
