class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def provider
    @user = User.find_for_oauth(auth_hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else              
      redirect_to auth_confirmations_new_path(provider: auth_hash.provider, uid: auth_hash.uid)
    end    
  end

  alias_method :twitter, :provider
  alias_method :facebook, :provider

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end