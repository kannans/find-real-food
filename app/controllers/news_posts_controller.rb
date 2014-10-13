class NewsPostsController < ApplicationController
  def index
  	@newsposts = NewsPost.paginate(page: params[:page], per_page: 3).order('title DESC')
  end
  def more_details
		
		@newspost = NewsPost.find(params[:slug])
		@newsposts = NewsPost.order('title DESC').last(10)
		 
	end
end
