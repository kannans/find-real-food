class PasswordResetsController < ApplicationController
  def new
  end


def create
  user = User.find_by_email(params[:email])
  user.send_password_reset if user
  flash[:success] = "An Email has been sent with reset password link"
  redirect_to new_password_reset_path
end

def edit
  @user = User.find_by_reset_password_token!(params[:id])
  
end

def update
  @user = User.find_by_reset_password_token!(params[:id])
  if @user.reset_password_sent_at < 2.hours.ago
  	flash[:notice] = "Password has been reset!"
    redirect_to new_password_reset_path
  elsif @user.update_attributes(params[:user])
  	flash[:success] = "Password has been reset!"
    redirect_to '/login'
  else
    render :edit
  end
end


end
