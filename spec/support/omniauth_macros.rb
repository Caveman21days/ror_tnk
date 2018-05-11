module OmniauthMacros

  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '123545',
      info: { email: 'blabla@example.com' }
    )
  end


  def mock_auth_without_email
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '123456',
      info: {}
    )
  end

  def mock_auth_invalid(provider)
    OmniAuth.config.mock_auth[provider] = :credentials_are_invalid
  end
end