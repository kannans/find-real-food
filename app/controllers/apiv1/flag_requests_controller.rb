class Api::FlagRequestsController < Api::BaseController
  respond_to :json

  api :POST, '/:flaggable_type/:flaggable_id/flags', "Flag an object"
  param :flag_request, Hash do
    param :comment, String
  end
  desc <<-EOS
    Valid Flaggable types: Product, Brand
  EOS
  def create
    begin
      params[:flag_request][:flaggable_type] = params[:flaggable_type].classify
      params[:flag_request][:flaggable_id] = params[:flaggable_id]
      @resource = current_user.flag_requests.new(params[:flag_request])

      @resource.save!
      respond_to do |format|
        format.json { render_for_api :flag_request, :json => @resource,
          :meta => { :success => true}, :root => :flag_request}
      end
    rescue Exception => e
      render :json => { :success => false, :message => e.message}
    end
  end
end
