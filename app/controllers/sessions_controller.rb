class SessionsController < Devise::SessionsController
  param :email, String
  param :password, String
  param :facebook_id, String
  desc <<-EOS
    Two valid combinations: Email/Password or Email/FacebookID
    Returns:
      { "authentication_token": "KpFsdzD2dBQTNgWmU2hK", "user_id": 1 }
  EOS

# def create1
#     user = User.from_omniauth(env["omniauth.auth"])
#     session[:user_id] = user.id
#     redirect_to root_url
# end
def create
    if params[:facebook_id]
      resource = User.where(:email => params[:email], :facebook_id => params[:facebook_id]).first
      if resource.nil?
        resource = User.create!(:email => params[:email], :facebook_id => params[:facebook_id], :password => "empty1234")
        resource.update_attributes!(params[:user])
        resource.reload
      end
    else
      resource = User.find_for_database_authentication(:email => params[:email])
    end

    return invalid_login_attempt unless resource

    valid_login = false

    if params[:facebook_id]
      valid_login = true if params[:facebook_id].to_s == resource.facebook_id
    else
      valid_login = resource.valid_password?(params[:password])
    end

    return invalid_login_attempt unless valid_login

    sign_in(:user, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def invalid_login_attempt
    warden.custom_failure!
    redirect_to "/login", notice: "Invalid Email address or Password."
  end
def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
end
end
