class ProductsController < ApplicationController

def index
	q=
	@products = Product.sort_by_rating(q)
	@brands = Brand.all
end

def more_details
	
	@product = Product.find(params[:slug])
	
end

def add_to_favorites
	
	@already_exists = Fovorite.where(user_id:current_user.id).where(reference_id: params[:product_id]).count
	if @already_exists < 1
	@favorite = Fovorite.create(user_id:current_user.id, type: "Product", reference_id: params[:product_id])
	@favorite.save
 	end
     
end

def add_comments
	
	@already_exists = Rating.where(user_id:current_user.id).where(ratable_id: params[:ratable_id]).count
	if @already_exists < 1
	@comment = Rating.create(user_id:current_user.id, ratable_type: "Product", ratable_id: params[:ratable_id], comment: params[:comment] )
	@comment.save
 	end
     
end


end
