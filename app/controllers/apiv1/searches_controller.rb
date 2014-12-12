class Apiv1::SearchesController < Apiv1::BaseController
  skip_filter :ensure_user_authentication!

  
  respond_to :json

  api :GET, '/search', "Perform a multi-object search"
   
  

  def search
    
     categories = Brand.approved
    respond_to do |format|
      format.json { render_for_api :category, :json => categories, :meta => { :success => true} }
    end

  end

  private

  def search_only(filter)
    return @filter = filter.classify.constantize
  end
end
