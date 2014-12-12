class Apiv1::SearchesController < Apiv1::BaseController
  skip_filter :ensure_user_authentication!

  
  respond_to :json

  api :GET, '/search', "Perform a multi-object search"
   
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
    
    @brands = Brand.approved
    
    respond_to do |format|
      format.json { render_for_api :search, :json => @brands, :meta => { :success => true} }
    end

  end

  private

  def search_only(filter)
    return @filter = filter.classify.constantize
  end
end
