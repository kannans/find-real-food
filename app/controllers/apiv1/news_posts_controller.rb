class Api::NewsPostsController < Api::BaseController
  skip_filter :ensure_user_authentication!
  
  respond_to :json

  api :GET, '/news_posts', "Get a listing of news posts"
  desc "Add ?limit=x to limit the number returned"
  def index
    unless params[:limit].nil?
      news_posts = NewsPost.order("created_at DESC").limit(params[:limit])
    else
      news_posts = NewsPost.order("created_at DESC")
    end

    respond_to do |format|
      format.json { render_for_api :news_post, :json => news_posts, :meta => { :success => true}, :root => :news_posts }
    end
  end
end
