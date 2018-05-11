class ConfirmationController < ApplicationController

  def send_confirmation_of_email
    auth = Authorization.new(provider: session[:auth]['provider'], uid: session[:auth]['uid'])
    @user = User.create_user_before_confirmation(params[:email], auth)

    if @user.email != params[:email]
      UserEmailMailer.with(email: params[:email], token: @user.confirmation_token).confirm_email.deliver_now
    end

    redirect_to root_path
  end

  def confirmation
    if user = User.where(confirmation_token: params[:token])
      user.update(confirmed_at: DateTime.now)

      # Здесь не работает sign_in_and_redirect, даже если в device_for добавить этот этот контроллер

      redirect_to root_path
    end
  end

end
