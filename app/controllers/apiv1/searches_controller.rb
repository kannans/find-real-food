class Apiv1::SearchesController < Api::BaseController
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
       @resources = {}
        @resources[:products] = Product.search_products().paginate(page: 1, per_page: 20)
        #@resources[:brands] = Brand.paginate(page: page, per_page: search_result_limit).search_brands().availabilityfilter(sold).searchtext(search)
        
        
    

    searchres = Search.new({
      
      :products => @resources[:products]
      
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
