class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def password_reset
  end

before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/login" &&
        request.path != "/users/auth/facebook/callback" &&
        request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end

    session[:previous_url] = '/user/profile' if request.path == '/register'
    puts "+" * 100
    p session[:previous_url]
    puts "+" * 100
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  
  def user_is_logged_in?
    !!session[:user_id]
  end
  
end
	