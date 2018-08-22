class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact(cont)
    @body = cont[:body]

    mail to: cont[:email],
         subject: cont[:subject]
  end
end
