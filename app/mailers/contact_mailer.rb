class ContactMailer < ActionMailer::Base
  default from: "rmarktest@gmail.com"
  def contact_mail(contact)
    @contact = contact[:txt_con_lname]
    mail(to: 'rmarktest1@gmail.com', subject: 'Find Real Food - Contact Us')
  end
end
