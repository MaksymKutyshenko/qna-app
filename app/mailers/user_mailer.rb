class UserMailer < ApplicationMailer
  def confirmation_mail(email, auth_token)
    @email = email
    @auth_token = auth_token
    mail(to: email, subject: 'Confirmaition email')
  end
end
