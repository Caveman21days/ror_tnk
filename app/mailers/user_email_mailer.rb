class UserEmailMailer < ApplicationMailer
  default from: 'putin@naumen.ru'

  def confirm_email
    @url = 'localhost:3000/confirmation/'
    @token = params[:token]
    mail(to: params[:email])
  end
end
