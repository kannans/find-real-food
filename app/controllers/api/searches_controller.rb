class Api::SearchesController < Api::BaseController
  skip_filter :ensure_user_authentication!
  
  # respond_to :json
 
  api :GET, '/search', "Perform a multi-object search"
  formats ['json']  
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

    unless q[:name_cont].nil?
      q[:name_cont_all] = q[:name_cont].split(' ')
      q[:title_cont_all] = q[:name_cont_all]
      q.delete(:name_cont)
    end

    f = q[:filter]
    q.delete(:filter)

    unless params[:sub_filter].nil?
      q[:order_by_phone_eq] = true if params[:sub_filter] == 'order_by_phone'
      q[:brand_order_by_phone_eq] = true if params[:sub_filter] == 'order_by_phone'

      q[:order_by_online_or_third_party_available_eq] = true if params[:sub_filter] == 'order_by_online'
      q[:brand_order_by_online_or_brand_third_party_available_eq] = true if params[:sub_filter] == 'order_by_online'

      q[:store_farmers_market_eq] = true if params[:sub_filter] == 'store_or_farmers_market'
      q[:brand_store_farmers_market_eq] = true if params[:sub_filter] == 'store_or_farmers_market'

    end

    @resources = {}

    if f == "Brand"
      q.delete(:category_id_eq)
      @resources[:brands] = Brand.approved.search(q)
    end

    if f == "Category"
      q.delete(:name_contains)
      q.delete(:category_id_eq)
      @resources[:categories] = Category.search(q)
    end

    if f == "Location"
      q.delete(:category_id_eq)
      @resources[:locations] = Location.search(q)
    end

    if f.nil? || f == "Product"
      if params[:sort] == "rating"
        @resources[:products] = Product.search_and_sort_by_rating(q)
      elsif params[:sort] == "quality"
        @resources[:products] = Product.search_and_sort_by_quality(q)
      else
        @resources[:products] = Product.search(q)
      end
    end

    @resources[:users] = User.search(q)  if f == "User"


   

    @search = {
      :brands => @resources[:brands].nil? ? nil : @resources[:brands].paginate(:per_page => search_result_limit, :page => params[:page]) ,
      :categories => @resources[:categories].nil? ? nil : @resources[:categories].paginate(:per_page => search_result_limit, :page => params[:page]) ,
      :locations => @resources[:locations].nil? ? nil : @resources[:locations].paginate(:per_page => search_result_limit, :page => params[:page]) ,
      :products => @resources[:products].nil? ? nil : @resources[:products].paginate(:per_page => search_result_limit, :page => params[:page]) ,
    }

    respond_to do |format|
      format.json {render json: @search }
    end
  end

  private

  def search_only(filter)
    return @filter = filter.classify.constantize
  end
end