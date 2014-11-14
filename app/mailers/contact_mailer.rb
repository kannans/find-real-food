class ContactMailer < ActionMailer::Base
  default from: "rmarktest@gmail.com"
  def contact_mail(contact)
    @contact = contact
    mail(to: 'rmarktest1@gmail.com', subject: 'Find Real Food - Contact Us')
  end
  
  def invite_send(invite)
    @invite = invite
    invite[:txtar_con_emails].split(',').each {|email| 
      mail(to: email, subject: invite[:sender_fname]+' '+invite[:sender_name]+' is Inviting you to Find Real Food')
     
    }

    
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
