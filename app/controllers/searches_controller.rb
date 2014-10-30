class SearchesController < ApplicationController
  param :search, String

  def index

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
    @locations = Location.near("#{zip}", 20)
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]
    rank = params[:rank]

    if @location !=''
      @products = Product.sort_by_rating(@location, search, '','',sort,  rank)
      @brands = Brand.search_by_locations_and_name(@location, search, sold)
       #@products_locations = Product.sort_by_rating(@location, search, '','',sort).collect{|c| c.location_id}.join(',')
 
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  