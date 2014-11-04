class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def password_reset
  end

  #def after_sign_in_path_for(user)
  	 
  
  #	session[:user_id] = user.id
   # puts URI(request.referer).path
    #abort(URI(request.referer).path)
     
  #end

  def after_sign_in_path_for resource
  	signed_in_root_path(resource)
  
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end
	