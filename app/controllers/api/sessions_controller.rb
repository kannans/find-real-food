class Api::SessionsController < Devise::SessionsController

  respond_to :json

  api :POST, '/users/sign_in', "Login a user"
  param :email, String
  param :password, String
  param :facebook_id, String
  desc <<-EOS
    Two valid combinations: Email/Password or Email/FacebookID
    Returns:
      { "authentication_token": "KpFsdzD2dBQTNgWmU2hK", "user_id": 1 }
  EOS
  def create
    if params[:facebook_id]
      resource = User.where(:email => params[:email], :facebook_id => params[:facebook_id]).first
      if resource.nil?
        resource = User.create!(:email => params[:email], :facebook_id => params[:facebook_id], :password => "empty1234")
        params[:user].delete(:id)
        params[:user][:avatar] = open(params[:user][:avatar])
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

    respond_to do |format|
      format.json { render_for_api :user, :json => current_user, :meta => { :success => true, :authentication_token => resource.authentication_token }, :root => :user }
    end
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json => { :errors => ["Invalid email or password."] },  :success => false, :status => :unauthorized
  end
end
