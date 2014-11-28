class Api::SubscriptionsController < Api::BaseController

  api :POST, '/users/:user_id/subscriptions', 'Add a subscription'
  param :subscription, Hash do
    param :subscription_type, String
  end

  def create
    begin
      user = User.find(params[:user_id])
      subscription = user.subscriptions.create!(params[:subscription])

      respond_to do |format|
        format.json { render_for_api :subscription, :json => subscription, :meta => { :success => true} }
      end
    rescue Exception => e
       render :json => {:success => false, :message => e.message }
    end
  end
end
