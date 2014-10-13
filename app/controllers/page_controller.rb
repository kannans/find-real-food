class PageController < ApplicationController
  def index
  	@page = Page.find(params[:slug])
  end
end
