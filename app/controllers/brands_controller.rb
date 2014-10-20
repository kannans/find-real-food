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
    @location = Location.near("#{zip}", 200).collect{|c| c.id}.join(',')
    
    if @location !=''
    @products = Product.sort_by_rating(@location,search,'',@brand)
    @products_locations = Product.sort_by_rating(@location,search,'',@brand).collect{|c| c.location_id}.join(',')
    end


	  @productsall = Product.sort_by_rating('',search,'',@brand)
    @locations = Location.near("#{zip}", 20)
 
  end

  def add_to_favorites
  
  @already_exists = Fovorite.where(user_id:current_user.id).where(reference_id: params[:brand_id]).where(type: "Brand").count
  if @already_exists < 1
  @favorite = Fovorite.create(user_id:current_user.id, type: "Brand", reference_id: params[:brand_id])
  @favorite.save
  end
     
end

def add_flag

  @flag = FlagRequest.create(user_id:current_user.id, flaggable_type: "Brand", flaggable_id: params[:brand_id], comment: params[:comment] )
  @flag.save

end


end
