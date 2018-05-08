class ConfirmationController < ApplicationController

  def send_confirmation_of_email
    @user = User.user_with_unconfirmed_authorization(params[:email])

    auth = Authorization.new
    auth.provider = session[:auth]['provider']
    auth.uid = session[:auth]['uid']

    @user.create_authorization(auth)

    UserEmailMailer.with(email: params[:email], token: @user.confirmation_token).confirm_email.deliver_now

    redirect_to root_path
  end

  def confirmation
    if user = User.where(confirmation_token: params[:token])
      user.update(confirmed_at: DateTime.now)
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'vkontakte') if is_navigational_format?
    end
  end
end
