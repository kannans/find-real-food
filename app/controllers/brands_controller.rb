class BrandsController < ApplicationController
  def index
  	@brand = Brand.find(params[:slug])

    if params[:zip]
      zip = params[:zip]
      session[:user] = zip
    elsif session[:user]
      zip = session[:user]
    else
      zip = '94123'
      session[:user] = zip
    end

    
    search = ''
    location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
    
    if location !=''
    @products = Product.sort_by_rating(location,search,'',@brand)
    end


	  @productsall = Product.sort_by_rating('',search,'',@brand)

	#@products =  Product.joins("LEFT OUTER JOIN ratings ON ratings.ratable_id = products.id AND ratable_type = 'Product'")
    #     .group("products.id")
    #      .select("count(ratings.rating) as rating_count,AVG(ratings.rating) as avg_rating, products.*")
    #      .where("products.brand_id=@brand.id").first(20) 
  #  @products = Product.where("brand_id=@brand.id").first(20) 
	
  end
end
