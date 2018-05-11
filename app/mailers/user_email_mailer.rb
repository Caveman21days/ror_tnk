class UserEmailMailer < ApplicationMailer
  default from: 'putin@naumen.ru'

  def confirm_email
    @token = params[:token]
    mail(to: params[:email])
  end
end
