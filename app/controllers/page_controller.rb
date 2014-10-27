  class PageController < ApplicationController
  def index
  	@page = Page.find(params[:slug])
  end

  def contact
  	#if params[:sbmt_con] =='Submit'
  	
  	ContactMailer.contact_mail(params).deliver
  	flash[:notice] = "Your Details have been Submited successfully, Administrator will contact you shortly"
  	redirect_to "/contact-us"
  	#end
  end
end
