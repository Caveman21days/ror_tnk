class ConfirmationController < ApplicationController

  def send_confirmation_of_email
    @user = User.user_with_unconfirmed_authorization(params[:email])

    auth = Authorization.new
    auth.provider = session[:auth]['provider']
    auth.uid = session[:auth]['uid']

    @user.create_authorization(auth) if !@user.authorizations.where(provider: auth.provider).first

    if @user.email != params[:email]
      UserEmailMailer.with(email: params[:email], token: @user.confirmation_token).confirm_email.deliver_now
    end

    redirect_to root_path
  end

  def confirmation
    if user = User.where(confirmation_token: params[:token])
      user.update(confirmed_at: DateTime.now)

      # Не знаю, как тут залогиниться и редиктнуться, поэтому приходится снова наживать на sign_in with #{provider}

      redirect_to root_path
    end
  end

end
