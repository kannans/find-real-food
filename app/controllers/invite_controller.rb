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
   	
   	ContactMailer.invite_send(params).deliver
  	flash[:notice] = "Your Invitation has been sent successfully."
  	redirect_to "/invite/index"
   end

  end

end
