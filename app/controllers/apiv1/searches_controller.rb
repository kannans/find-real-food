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
    search_result_limit = 20

    q = params[:q]

    #unless q[:name_cont].nil?
    #  q[:name_cont_all] = q[:name_cont].split(' ')
    #  q[:title_cont_all] = q[:name_cont_all]
    #  q.delete(:name_cont)
    #end
    
    search  = q[:name_cont]
    

    f = q[:filter]

    unless params[:sub_filter].nil?
      q[:order_by_phone_eq] = true if params[:sub_filter] == 'order_by_phone'
      q[:brand_order_by_phone_eq] = true if params[:sub_filter] == 'order_by_phone'

      q[:order_by_online_or_third_party_available_eq] = true if params[:sub_filter] == 'order_by_online'
      q[:brand_order_by_online_or_brand_third_party_available_eq] = true if params[:sub_filter] == 'order_by_online'

      q[:store_farmers_market_eq] = true if params[:sub_filter] == 'store_or_farmers_market'
      q[:brand_store_farmers_market_eq] = true if params[:sub_filter] == 'store_or_farmers_market'

    end

    @resources = {}

    #@resources[:brands] = Brand.approved.search(q).result if f.nil? || f == "Brand"
    @resources[:brands] = Brand.approved.search_brands().searchtext(search) if f.nil? || f == "Brand"
    
    #@resources[:categories] = Category.search(q).result  if f.nil? || f == "Category"
    @resources[:categories] = Category.where("title like '%#{search}%'")  if f.nil? || f == "Category"
    @resources[:locations] = Location.where("name like '%#{search}%'")  if f.nil? || f == "Location"

    if f.nil? || f == "Product"
      if params[:sort] == "rating"
        #@resources[:products] = Product.search_and_sort_by_rating(q).result
        @resources[:products] = Product.search_products().sortorder('rating')
      elsif params[:sort] == "quality"
        #@resources[:products] = Product.search_and_sort_by_quality(q).result
        @resources[:products] = Product.search_products().sortorder('quality')
      else
        @resources[:products] = Product.search_products().sortorder('rating')
      end
    end

    @resources[:users] = User.where("name like '%#{search}%'")  if f.nil? || f == "User"
    

    if q[:category_id_eq].to_i > 0
      
      q[:products_category_id_eq] = q[:category_id_eq]
      @brand_ids = Product.search_products().categoryfilter(q[:category_id_eq]).collect{|b| b.brand_id}.join(',')
      @resources[:brands] = Brand.where("id in (#{@brand_ids})")
      @resources[:categories] = nil
      @resources[:users] = nil  
    end

    search = Search.new({
      :brands => @resources[:brands].nil? ? nil : @resources[:brands].paginate(:per_page => search_result_limit, :page => params[:page]),
      :categories => @resources[:categories].nil? ? nil : @resources[:categories].paginate(:per_page => search_result_limit, :page => params[:page]),
      :locations => @resources[:locations].nil? ? nil : @resources[:locations].paginate(:per_page => search_result_limit, :page => params[:page]),
      :products => @resources[:products].nil? ? nil : @resources[:products].paginate(:per_page => search_result_limit, :page => params[:page]),
      :users => @resources[:users].nil? ? nil : @resources[:users].paginate(:per_page => search_result_limit, :page => params[:page]),
      :pages => {
        :brands => @resources[:brands].nil? ? 0 : (@resources[:brands].length / search_result_limit.to_f).ceil,
        :categories => @resources[:categories].nil? ? 0 : (@resources[:categories].length / search_result_limit.to_f).ceil,
        :locations => @resources[:locations].nil? ? 0 : (@resources[:locations].length / search_result_limit.to_f).ceil,
        :products => @resources[:products].nil? ? 0 : (@resources[:products].length / search_result_limit.to_f).ceil,
        :users => @resources[:users].nil? ? 0 : (@resources[:users].length / search_result_limit.to_f).ceil
      }
    })

    respond_to do |format|
      format.json { render_for_api :search, :json => search, :meta => { :success => true} }
    end

  end

  private

  def search_only(filter)
    return @filter = filter.classify.constantize
  end
end
