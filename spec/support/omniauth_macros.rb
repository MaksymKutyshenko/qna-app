module OmniauthMacros
  def mock_auth_hash(provider, provider_data = {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '1235456'
    }.merge(provider_data))
  end
end