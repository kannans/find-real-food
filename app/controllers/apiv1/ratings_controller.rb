class Apiv1::RatingsController < Apiv1::BaseController
  respond_to :json

  api :POST, '/:ratable_type/:ratable_id/ratings', "Rate a Product/Brand/Location"
  param :rating, Hash do
    param :rating, Integer
    param :comment, String
  end
  desc <<-EOS
    :ratable_type is a ratable object (Product, Brand, Location)\n
    :ratable_id is the ID of the ratable object
  EOS

  def create
    begin
      params[:rating][:ratable_type] = params[:ratable_type].classify
      params[:rating][:ratable_id] = params[:ratable_id]

      @resource = current_user.ratings.new(params[:rating])
      @resource.save!


      respond_to do |format|
        format.json { render_for_api :rating, :json => @resource,
          :meta => { :success => true}, :root => :rating}
      end
    rescue Exception => e
      render :json => { :success => false, :message => e.message}
    end
  end
end
