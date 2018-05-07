class UserEmailMailer < ApplicationMailer
  default from: 'from@qna.com'

  def confirm_email
    @url = '127.0.0.1:3000/email_confirmation'
    mail(to: params[:email])
  end
end
