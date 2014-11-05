class NewsPostsController < ApplicationController
  def index
  	@newsposts = NewsPost.paginate(page: params[:page], per_page: 3).order('created_at DESC')
  end
  def more_details
		
		@newspost = NewsPost.find(params[:slug])
		@newsposts = NewsPost.order('created_at DESC').last(10)
		 
	end
end
