class SearchesController < ApplicationController
  param :search, String

  def index
    if params[:zip]
    zip = params[:zip]
    session[:zip] = zip
    else
      zip = session[:zip]
    end
    @location = Location.near("#{zip}", 10).collect{|c| c.id}.join(',')
    @centerlocation = Location.near("#{zip}", 10).first

    

    
    if params[:search]
      search = params[:search].gsub("'", "\\\\'")
      session[:search] = search
    else 
      search = session[:search]
      
    end

    if params[:sort]
      sort = params[:sort]
      session[:sort] = sort
    else
      sort = session[:sort]
    end
    
    if params[:sold]
      sold = params[:sold]
      session[:sold] = sold
    else
      sold = session[:sold]
      
    end
    
    if params[:rank]
      rank = params[:rank]
      session[:rank] = rank
    else
      rank = session[:rank]
      
    end
    
    if  params[:category]
      category = params[:category] 
      session[:category] = category
    else
      category = session[:category]

    end
    

    
    @current_page ='search';

    if sold=='' and zip !=''
      sold = 'store'
    end


    if search
       categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
    else
       categories =''
    end

    if @location !=''
       
        if categories!=''
          @cat_productsnear = Product.search_products(@location).categorysearch(categories).qualityfilter(rank).availabilityfilter('sold').collect{|c| c.id}.join(',')
        end
       
        @product_listnear = Product.search_products(@location).categoryfilter(category).availabilityfilter('sold').qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_idsnear = @cat_productsnear + @product_listnear
        else
          @product_idsnear = @product_listnear
        end        
       if @product_idsnear!=''
          @productsnear = Product.search_products().where("products.id in (#{@product_idsnear})").paginate(page: 1, per_page: 30).sortorder(sort)
       else
          @productsnear = "";
       end
          @products_locations = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter('store').sortorder(sort).searchtext(search).collect{|c| c.location_id}.join(',')
       if @products_locations!=''
          @locations = Location.where("id in (#{@products_locations})")
       end
    end
       

        if categories!=''
          @cat_products = Product.search_products().categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).collect{|c| c.id}.join(',')
        end
        @product_list = Product.search_products().categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_ids = @cat_products + @product_list
        else
          @product_ids = @product_list
        end        
        if @product_ids!=''
          @products = Product.search_products().where("products.id in (#{@product_ids})").paginate(page: 1, per_page: 30).sortorder(sort)
          @brandids2 = Product.search_products().where("products.id in (#{@product_ids})").collect{|c| c.brand_id}.join(',')
        else
          @products = "";
        end

        @brandids1 = Brand.search_brands().availabilityfilter(sold).searchtext(search).collect{|c| c.id}.join(',')
        if @brandids2
          @brand_ids = @brandids1 + @brandids2
        else
          @brand_ids = @brandids1
        end 
        if @brand_ids!=''
          @brands = Brand.where("id in (#{@brand_ids})").paginate(page: 1, per_page: 30)
        else
          @brands = "";
        end


    respond_to do |format|
      format.html
      format.js
    end

  end
 
 def showmore
    
    zip = session[:zip]
    @location = Location.near("#{zip}", 10).collect{|c| c.id}.join(',')
    @centerlocation = Location.near("#{zip}", 10).first
    
    if params[:search]
      search = params[:search].gsub("'", "\\\\'")
      session[:search] = search
    else 
      search = session[:search]
      
    end

    if params[:sort]
      sort = params[:sort]
      session[:sort] = sort
    else
      sort = session[:sort]
    end
    
    if params[:sold]
      sold = params[:sold]
      session[:sold] = sold
    else
      sold = session[:sold]
      
    end
    
    if params[:rank]
      rank = params[:rank]
      session[:rank] = rank
    else
      rank = session[:rank]
      
    end
    
    if  params[:category]
      category = params[:category] 
      session[:category] = category
    else
      category = session[:category]

    end


    @current_page ='search';
    if params[:page]
        page = params[:page]
    else
        page = 1
    end

    if sold=='' and zip !=''
      sold = 'store'
    end
    
   

   if search
       categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
    else
       categories =''
    end

    if @location !=''
       
        if categories!=''
          @cat_productsnear = Product.search_products(@location).categorysearch(categories).qualityfilter(rank).availabilityfilter('sold').collect{|c| c.id}.join(',')
        end
       
        @product_listnear = Product.search_products(@location).categoryfilter(category).availabilityfilter('sold').qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_idsnear = @cat_productsnear + @product_listnear
        else
          @product_idsnear = @product_listnear
        end        
       if @product_idsnear!=''
          @productsnear = Product.search_products().where("products.id in (#{@product_idsnear})").paginate(page: page, per_page: 30).sortorder(sort)
       else
          @productsnear = "";
       end
          @products_locations = Product.search_products(@location).categoryfilter(category).qualityfilter(rank).availabilityfilter('store').sortorder(sort).searchtext(search).collect{|c| c.location_id}.join(',')
       if @products_locations!=''
          @locations = Location.where("id in (#{@products_locations})")
       end
    end
       

        if categories!=''
          @cat_products = Product.search_products().categorysearch(categories).qualityfilter(rank).availabilityfilter(sold).collect{|c| c.id}.join(',')
        end
        @product_list = Product.search_products().categoryfilter(category).availabilityfilter(sold).qualityfilter(rank).searchtext(search).collect{|c| c.id}.join(',')
        if categories!=''
          @product_ids = @cat_products + @product_list
        else
          @product_ids = @product_list
        end        
      if @product_ids!=''
        @products = Product.search_products().where("products.id in (#{@product_ids})").paginate(page: page, per_page: 30).sortorder(sort)
        @brandids2 = Product.search_products().where("products.id in (#{@product_ids})").collect{|c| c.brand_id}.join(',')
      else
        @products = "";
      end
        
        @brandids1 = Brand.search_brands().availabilityfilter(sold).searchtext(search).collect{|c| c.id}.join(',')
        if @brandids2
          @brand_ids = @brandids1 + @brandids2
        else
          @brand_ids = @brandids1
        end 
        if @brand_ids!=''
          @brands = Brand.where("id in (#{@brand_ids})").paginate(page: page, per_page: 30)
        else
          @brands = "";
        end
    
    

    respond_to do |format|
      format.html
      format.js
    end

  end

   

end  