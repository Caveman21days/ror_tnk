class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte, :twitter]


  def author_of?(obj)
    self.id == obj.user_id
  end


  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization && authorization.user.confirmed_at

    if auth.info[:email]
      email = auth.info[:email]
      user = User.where(email: email).where.not(confirmed_at: nil).first

      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
      return user
    else
      return nil
    end
  end


  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end


  def self.user_with_unconfirmed_authorization(email)
    user = User.where(email: email).first
    password = Devise.friendly_token[0, 20]

    if user
      user.update!(confirmation_token: Devise.token_generator.generate(User, :confirmation_token)[1])
    else
      user = User.create!(
        email: email,
        password: password,
        password_confirmation: password,
        confirmation_token: Devise.token_generator.generate(User, :confirmation_token)[1]
      )
    end
    user
  end


  def self.create_user_before_confirmation(email, auth)
    user = User.user_with_unconfirmed_authorization(email)
    user.create_authorization(auth) if !user.authorizations.where(provider: auth.provider).first
    user

    if user.email != email
      UserEmailMailer.with(email: email, token: user.confirmation_token).confirm_email.deliver_now
    end
  end
end
