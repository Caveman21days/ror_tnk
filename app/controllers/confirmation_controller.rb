class ConfirmationController < ApplicationController

  def send_confirmation_of_email
    p '========================'
    p params
    UserEmailMailer.with(email: params[:email]).confirm_email.deliver_now
    redirect_to root_path
  end

end
