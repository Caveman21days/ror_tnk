class ConfirmationController < ApplicationController

  def send_confirmation_of_email
    auth = Authorization.new(provider: session[:auth]['provider'], uid: session[:auth]['uid'])
    @user = User.create_user_before_confirmation(params[:email], auth)
    redirect_to root_path, notice: 'Email successfully sended'
  end

  def confirmation
    if user = User.where(confirmation_token: params[:token])
      user.update(confirmed_at: DateTime.now)
      redirect_to root_path
    end
  end

end
