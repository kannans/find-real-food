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

    location = Location.near("#{zip}", 200).collect{|c| c.id}.join(',')
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]

    if location !=''
      @products = Product.sort_by_rating(location, search, '','',sort)
      @brands = Brand.search_by_locations_and_name(location, search, sold)
 
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  