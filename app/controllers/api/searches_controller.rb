class Api::SearchesController < Api::BaseController
  skip_filter :ensure_user_authentication!
  
  respond_to :json

  api :GET, '/search', "Get a listing of all categories"
  def search
    categories = Category.unscoped.order(:sort)
    respond_to do |format|
      format.json { render_for_api :category, :json => categories, :meta => { :success => true} }
    end
  end
end
