class Apiv1::BaseController < ApplicationController

  respond_to :json

  before_filter :ensure_user_authentication!

  def ensure_user_authentication!
    begin
      user = User.find_for_database_authentication(:authentication_token => params[:auth_token])
      render_failure if user.nil?
    rescue
      render_failure
    end
  end

  private
    def render_failure
      render :json => { :success => false, :message => "Access Denied"}
    end
end
