class ContactMailer < ActionMailer::Base
  default from: "rmarktest@gmail.com"
  def contact_mail(contact)
    @contact = contact
    mail(to: 'rmarktest1@gmail.com', subject: 'Find Real Food - Contact Us')
  end

  def forgot_mail(user)
    @user = user
    mail(to: 'rmarktest1@gmail.com', subject: 'Find Real Food - Login Credentials')
  end

	def password_reset(user)
	  @user = user
	  mail :to => user.email, :subject => "Password Reset"
	end



end
