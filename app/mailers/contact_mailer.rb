class ContactMailer < ActionMailer::Base
  default from: "rmarktest@gmail.com"
  def contact_mail(contact)
    @contact = contact
    mail(to: 'rmarktest1@gmail.com', subject: 'Find Real Food - Contact Us')
  end
end
