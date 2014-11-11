class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
        @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

        if @user.persisted?
            puts @user.inspect
            # flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
            flash[:notice] = "devise.omniauth_callbacks.success"
            sign_in_and_redirect @user, :event => :authentication
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]
            redirect_to "/login"
        end
    end
end