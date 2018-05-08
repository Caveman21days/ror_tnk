class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize


  def vkontakte; end

  def twitter; end


  private

  def authorize
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'vkontakte') if is_navigational_format?
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
