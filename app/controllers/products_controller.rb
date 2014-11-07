class ProductsController < ApplicationController

def index
	q=
	@products = Product.sort_by_rating(q)
	@brands = Brand.all
	
end

def more_details
	
	if user_signed_in?

	if params[:zip]
      zip = params[:zip]
      session[:zip] = zip
    elsif session[:zip]
      zip = session[:zip]
    else
      zip = '94123'
      session[:zip] = zip
    end
    @location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')

	@product = Product.find(params[:slug])
	if @location
		@similar_product  = Product.search_products(@location).categoryfilter(@product.category_id).sortorder().first(20)
    else
    	@similar_product  = Product.search_products().categoryfilter(@product.category_id).sortorder().first(20)
    end
	@locations = Location.near("#{zip}", 20)

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


end
