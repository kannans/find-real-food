class Api::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  api :POST, '/users', "Create a user"
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

  def create
    params[:user].delete(:avatar_data) if params[:user][:avatar_data].nil?
    params[:user].delete(:cover_photo_data) if params[:user][:cover_photo_data].nil?

    if params[:user][:avatar_data]
      avatar_data = params[:user][:avatar_data]
      params[:user].delete(:avatar_data)
    end

    if params[:user][:cover_photo_data]
      cover_photo_data = params[:user][:cover_photo_data]
      params[:user].delete(:cover_photo_data)
    end

    build_resource(params[:user])

    begin
      resource.avatar = RealFood::ImageDecoder.decode_jpg(avatar_data) if avatar_data
      resource.cover_photo = RealFood::ImageDecoder.decode_jpg(cover_photo_data) if cover_photo_data

      resource.save
      respond_to do |format|
       format.json { render_for_api :user, :json => resource, :meta =>
         { :success => true}, :root => :user }
     end
     rescue Exception => e
     render :json=> {:success => false, :message => e.message}
    end
  end
end

