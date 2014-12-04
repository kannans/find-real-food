class InviteController < ApplicationController
  def index
  	if user_signed_in?
  		@user = User.find(current_user.id)
   	else
   		redirect_to "/login"
   	end
  end

  def sendinvite

   if params[:sbmt_con] =='Submit'
   	params[:txtar_con_emails].split(",").each do |emailval|
   	ContactMailer.invite_send(params,emailval).deliver
    end
  	flash[:notice] = "Your Invitation has been sent successfully."
  	redirect_to "/invite/index"
   end

  end

end
