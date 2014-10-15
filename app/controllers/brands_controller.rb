class BrandsController < ApplicationController
  def index
  	@brand = Brand.find(params[:slug])

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
    location = Location.near("#{zip}", 200).collect{|c| c.id}.join(',')
    
    if location !=''
    @products = Product.sort_by_rating(location,search,'',@brand)
    end


	  @productsall = Product.sort_by_rating('',search,'',@brand)
    @locations = Location.near("#{zip}", 20)
	#@products =  Product.joins("LEFT OUTER JOIN ratings ON ratings.ratable_id = products.id AND ratable_type = 'Product'")
    #     .group("products.id")
    #      .select("count(ratings.rating) as rating_count,AVG(ratings.rating) as avg_rating, products.*")
    #      .where("products.brand_id=@brand.id").first(20) 
  #  @products = Product.where("brand_id=@brand.id").first(20) 
	
  end

  def add_to_favorites
  
  @already_exists = Fovorite.where(user_id:current_user.id).where(reference_id: params[:brand_id]).where(type: "Brand").count
  if @already_exists < 1
  @favorite = Fovorite.create(user_id:current_user.id, type: "Brand", reference_id: params[:brand_id])
  @favorite.save
  end
     
end



end
