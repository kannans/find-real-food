class SearchesController < ApplicationController
  param :search, String

  def index
    zip = params[:zip]
    @location = Location.near("#{zip}", 20).collect{|c| c.id}.join(',')
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]
    rank = params[:rank]
    category = params[:category]

    if @location !=''
      if user_signed_in?
        @products = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).first(20)
        @brands = Brand.search_brands(@location).availabilityfilter(sold).searchtext(search).first(20)
      else
        @products = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).first(12)
        @brands = Brand.search_brands(@location).availabilityfilter(sold).searchtext(search).first(12)
      end 
      @products_locations = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).collect{|c| c.location_id}.join(',')
      if @products_locations!=''
        @locations = Location.where("id in (#{@products_locations})")
      end
    else
      if user_signed_in?
      @products = Product.search_products().categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).first(20)
      @brands = Brand.search_brands().availabilityfilter(sold).searchtext(search).first(20)
      else
      @products = Product.search_products().categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).first(12)
      @brands = Brand.search_brands().availabilityfilter(sold).searchtext(search).first(12)
      end
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  