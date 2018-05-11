class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize


  def vkontakte; end

  def twitter; end


  private

  def authorize
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user
      if @user.persisted? && @user.confirmed_at
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: request.env['omniauth.auth'].provider) if is_navigational_format?
      else
        redirect_to new_user_session_path, notice: 'Something gone wrong, try to sign in again or confirm your email!'
      end
    else
      session[:auth] = {
        provider: request.env['omniauth.auth'].provider,
        uid: request.env['omniauth.auth'].uid
      }
      render 'shared/email_confirmation'
    end
  end
end
