class FaqController < ApplicationController
  def index
  	@faqs = Faq.all

  @user = User.find_by_email('rmarktest@gmail.com')
  ContactMailer.forgot_mail(@user).deliver

  end
end
