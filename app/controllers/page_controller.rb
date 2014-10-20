class PageController < ApplicationController
  def index
  	@page = Page.find(params[:slug])
  end

  def contact
  	params[:txt_con_lname]
  	ContactMailer.contact_mail(params[:txt_con_lname]).deliver
  end
end
