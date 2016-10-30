class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(auth_hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end    
  end

  def twitter
    render json: auth_hash
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end