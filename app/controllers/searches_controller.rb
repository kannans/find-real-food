class SearchesController < ApplicationController
  param :search, String

  def index
    zip = params[:zip]
    @location = Location.near("#{zip}", 200).collect{|c| c.id}.join(',')
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]
    rank = params[:rank]
    category = params[:category]

    if @location !=''
        
        categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
        
        if categories!=''
          
          @cat_products = Product.search_products(@location).categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).first(20)
          remaining = 20 - @cat_products.count
        else
          
          remaining = 20
        end

        
        @product_list = Product.search_products(@location).categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).sortorder(sort).searchtext(search).first(remaining)
        if categories!=''
          @products = @cat_products + @product_list
        else
          @products = @product_list
        end
        @products.uniq

        @brands = Brand.search_brands(@location).availabilityfilter(sold).searchtext(search).first(20)
        @products_locations = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).searchtext(search).collect{|c| c.location_id}.join(',')
        if @products_locations!=''
          @locations = Location.where("id in (#{@products_locations})")
        end
    else
        categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
        
        if categories!=''
          
          @cat_products = Product.search_products().categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).sortorder(sort).first(20)
          remaining = 20 - @cat_products.count
        else
          
          remaining = 20
        end

        
        @product_list = Product.search_products().categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).sortorder(sort).searchtext(search).first(remaining)
        if categories!=''
          @products = @cat_products + @product_list
        else
          @products = @product_list
        end
        @products.uniq
        @brands = Brand.search_brands().availabilityfilter(sold).searchtext(search).first(20)
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  