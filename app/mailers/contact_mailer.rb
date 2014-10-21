class ContactMailer < ActionMailer::Base
  default from: "rmarktest@gmail.com"
  def contact_mail(contact)
    @contact = contact
    mail(to: 'rmarktest1@gmail.com', subject: 'Find Real Food - Contact Us')
  end
end
#@contact.fname = params[:txt_con_lname]
  	#@contact.lname = params[:txt_con_lname]
  	#@contact.email = params[:txt_con_email]
  	#@contact.phone = params[:txt_con_ph]
  	#@contact.comment = params[:txtar_con_comments]