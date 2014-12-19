class Apiv1::FeedbacksController < Apiv1::BaseController
  respond_to :json

  api :POST, '/feedback', "Create user feedback"
  param :feedback, Hash do
    param :subject, String
    param :message, String
  end

  def create
    @resource = current_user.feedbacks.new(params[:feedback])

    begin
      @resource.save!

      respond_to do |format|
        format.json { render_for_api :feedback, :json => @resource,
          :meta => { :success =>true}, :root => :feedback}
      end
    rescue Exception => e
      render :json => { :success => false, :message => e.message}
    end
  end
end

