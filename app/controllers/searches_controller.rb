class SearchesController < ApplicationController
  param :search, String

  def index

    if params[:zip]
      zip = params[:zip]
      session[:user] = zip
    elsif session[:user]
      zip = session[:user]
    else
      zip = '94123'
      session[:user] = zip
    end

    

    location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
    search = params[:search]
    sort = params[:sort]
    sort = 'name' if sort.nil? || sort=='alphabetical' || sort=='proximity'
    sold = params[:sold]

    if location !=''
      @products = Product.sort_by_rating(location, search)
      @brands = Brand.search_by_locations_and_name(location, search, sold)

    else
      @products = Product.sort_by_rating('', search)
      @brands = Brand.search_by_locations_and_name('', search, sold)

    end
    


     
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  