class Api::SearchesController < Api::BaseController
  skip_filter :ensure_user_authentication!
  
  respond_to :json

  api :GET, '/search', "Perform a multi-object search"
  param :q, Hash do
    param :name_cont, String, :desc => "Object name contains"
    param :filter, String, :desc => "A specific type to search (User, Brand, Product, Category)"
    param :quality_rating_value_eq, String, :desc => ""
  end
  desc <<-EOT
    Params are passed in the url via ?q[]

    ?q[ brand ]\n
    ?q[ filter ]\n
    ?q[ quality_rating_name_eq ]

    ?q[ category_id_eq ]
      Searches by a specific category id. If present also limits the search to just products.

    To sort products:
    sort=quality
    sort=rating
  EOT

  def search
    search_result_limit = 20

    q = params[:q]

    search =  q[:name_cont]
    sort = 'rating'
    sold = ''
    
    f = q[:filter]

    unless params[:sub_filter].nil?
      sold = 'phone' if params[:sub_filter] == 'order_by_phone'
      sold='online' if params[:sub_filter] == 'order_by_online'
      sold='store' if params[:sub_filter] == 'store_or_farmers_market'
    end

    @resources = {}

     if search
          categories = Category.where("title like '%#{search}%'").collect{|c| c.id}.join(',')
       else
          categories =''
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
      else
        @products = "";
      end
        @resources[:brands] = Brand.paginate(page: 1, per_page: 30).search_brands().availabilityfilter(sold).searchtext(search)


    searchres = Search.new({
      :brands => @resources[:brands].nil? ? nil : @resources[:brands]),
       
      }
    })

    respond_to do |format|
      format.json { render_for_api :search, :json => searchres, :meta => { :success => true} }
    end

  end

  private

  def search_only(filter)
    return @filter = filter.classify.constantize
  end
end
