class SearchesController < ApplicationController
  param :search, String

  def index
    zip = params[:zip]
    session[:zip] = zip
    @location = Location.near("#{zip}", 50).collect{|c| c.id}.join(',')
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]
    rank = params[:rank]
    category = params[:category]
    @current_page ='search';
    if @location !=''
        
        categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
        if categories!=''
          @cat_products = Product.search_products(@location@location).categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).collect{|c| c.id}.join(',')
        end
        @product_list = Product.search_products(@location).categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_ids = @cat_products + @product_list
        else
          @product_ids = @product_list
        end        
      
        @products = Product.search_products().where("products.id in (#{@product_ids})").paginate(page: 1, per_page: 30).sortorder(sort)
        @brands = Brand.search_brands(@location).availabilityfilter(sold).searchtext(search).paginate(page: 1, per_page: 30)
        @products_locations = Product.search_products().where("products.id in (#{@product_ids})").collect{|c| c.location_id}.join(',')
        if @products_locations!=''
          @locations = Location.where("id in (#{@products_locations})")
        end
    else
        categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
        if categories!=''
          @cat_products = Product.search_products().categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).collect{|c| c.id}.join(',')
        end
        @product_list = Product.search_products().categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_ids = @cat_products + @product_list
        else
          @product_ids = @product_list
        end        
      
        @products = Product.search_products().where("products.id in (#{@product_ids})").paginate(page: 1, per_page: 30).sortorder(sort)
        @brands = Brand.search_brands().availabilityfilter(sold).searchtext(search).paginate(page: 1, per_page: 30)

    end
    respond_to do |format|
      format.html
      format.js
    end

  end
 
 def showmore
    zip = params[:zip]
    session[:zip] = zip
    @location = Location.near("#{zip}", 50).collect{|c| c.id}.join(',')
    search = params[:search]
    sort = params[:sort]
    sold = params[:sold]
    rank = params[:rank]
    category = params[:category]
    @current_page ='search';
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
          @cat_products = Product.search_products().categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).collect{|c| c.id}.join(',')
        end
        @product_list = Product.search_products().categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_ids = @cat_products + @product_list
        else
          @product_ids = @product_list
        end
        
        if params[:page]
          page = params[:page]
        else
          page = 1
        end

        @products = Product.search_products().where("products.id in (#{@product_ids})").paginate(page: page, per_page: 30).sortorder(sort)

        @brands = Brand.search_brands().availabilityfilter(sold).searchtext(search).paginate(page: page, per_page: 30)
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  