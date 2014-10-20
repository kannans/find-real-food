class PageController < ApplicationController
  def index
  	@page = Page.find(params[:slug])
  end

  def contact
  	if params[:sbmt_con] !=''
  	#@contact.fname = params[:txt_con_lname]
  	#@contact.lname = params[:txt_con_lname]
  	#@contact.email = params[:txt_con_email]
  	#@contact.phone = params[:txt_con_ph]
  	#@contact.comment = params[:txtar_con_comments]
  	ContactMailer.contact_mail(params).deliver
  	flash[:notice] = "Your Details have been Submited successfully, Administrator will contact you shortly"
  	redirect_to "/contact-us"
  	end
  end
end
