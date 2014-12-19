class Apiv1::UsersController < Apiv1::BaseController
  respond_to :json
  skip_filter :ensure_user_authentication!, :only => :reset_password

  api :GET, 'users/:id', "Get a specific user"
  def show
    begin
      user = User.find(params[:id])
      respond_to do |format|
        format.json { render_for_api :user, :json => user, :meta => { :success => true}, :root => :user }
      end
    rescue Exception => e
       render :json => {:success => false, :message => e.message }
    end
  end

  api :PUT, '/users/:id', "Update a user"
  param :user, Hash do
    param :email, String
    param :password, String
    param :password_confirmation, String
    param :city, String
    param :state, String
    param :facebook_id, String
    param :avatar_data, Hash, :desc => "Base64 encoded image data"
    param :cover_photo_data, Hash, :desc => "Base64 encoded image data"
  end

  def update
    params[:user].delete(:avatar_data) if params[:user][:avatar_data].nil?
    params[:user].delete(:cover_photo_data) if params[:user][:cover_photo_data].nil?

    params[:user].delete(:password) if params[:user][:password].nil?
    params[:user].delete(:password_confirmation) if params[:user][:password].nil?

    if params[:user][:avatar_data]
      avatar_data = params[:user][:avatar_data]
      params[:user].delete(:avatar_data)
    end

    if params[:user][:cover_photo_data]
      cover_photo_data = params[:user][:cover_photo_data]
      params[:user].delete(:cover_photo_data)
    end

    begin
      current_user.avatar = RealFood::ImageDecoder.decode_jpg(avatar_data) if avatar_data
      current_user.cover_photo = RealFood::ImageDecoder.decode_jpg(cover_photo_data) if cover_photo_data

      current_user.update_attributes!(params[:user])
      respond_to do |format|
        format.json { render_for_api :user, :json => current_user, :meta => { :success => true}, :root => :user }
      end
    rescue Exception => e
       render :json => {:success => false, :message => e.message }
    end
  end

  api :POST, '/password/reset', 'Send a reset password email for specified user.'
  param :email, String
  def reset_password
    begin
      user = User.where(:email => params[:email]).first
      user.send_reset_password_instructions
      render :json => { :success => true }
    rescue Exception => e
      render :json => { :success => false, :message => e.message }
    end
  end
end
