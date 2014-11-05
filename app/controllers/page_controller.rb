  class PageController < ApplicationController
  def index
  	@page = Page.find(params[:slug])
  end

  def contact
  	if params[:sbmt_con] =='Submit'
  	
  	ContactMailer.contact_mail(params).deliver
  	flash[:notice] = "Your details have been submitted successfully. We will contact you shortly. Thank you!"
  	redirect_to "/contact-us"
  	
    end
  end
end
