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
    
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]
    rank = params[:rank]
    category = params[:category]

    if @location !=''
      @products = Product.search_products().categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).first(20)
      @brands = Brand.search_by_locations_and_name('', search, sold)
      @products_locations = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).collect{|c| c.location_id}.join(',')
      if @products_locations!=''
      @locations = Location.where("id in (#{@products_locations})")
      end
    else
      @locations = Location.near("#{zip}", 20)
      @products = Product.search_products().categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).first(20)
      @brands = Brand.search_by_locations_and_name('', search, sold)
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  