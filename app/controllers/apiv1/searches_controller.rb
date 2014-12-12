class Apiv1::SearchesController < Apiv1::BaseController
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

    unless q[:name_cont].nil?
      searchval = q[:name_cont]
      #q[:name_cont_all] = q[:name_cont].split(' ')
      #q[:title_cont_all] = q[:name_cont_all]
      #q.delete(:name_cont)
    else
      searchval = ''
    end

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

    @resources[:brands] = @brands = Brand.search_brands().availabilityfilter('sold').paginate(page: 1, per_page: 30).searchtext(searchval) if f.nil? || f == "Brand"
    @resources[:users] = nil
    @resources[:categories] = nil
 
    search = Search.new({
      :brands => @resources[:brands].nil? ? nil : @resources[:brands])
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
