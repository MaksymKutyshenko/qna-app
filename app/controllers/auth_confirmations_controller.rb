class AuthConfirmationsController < ApplicationController
  after_action :create_omniauth_session, only: [:new]
  after_action :remove_omniauth_session, only: [:finish]
  before_action :load_oauth_user, only: [:finish]

  skip_authorization_check

  def create   
    if session_valid? && params[:email].present?
      UserMailer.confirmation_mail(params[:email], session[:omniauth]['auth_token']).deliver_now
      flash[:notice] = 'Confirmation mail was sent to your email address'
    else
      flash[:alert] = 'Confirmation mail was not sent.'
    end    
    redirect_to new_user_session_path
  end
  
  def finish  
    if @user && @user.persisted?
      flash[:alert] = 'Authorization complete.'
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = 'Authorization failed.'
      redirect_to new_user_session_path
    end   
  end 

  private

  def auth_token_valid?
    session[:omniauth]['auth_token'] == params[:auth_token]    
  end

  def session_valid?
    session[:omniauth].present?
  end

  def load_oauth_user
    if session_valid? && auth_token_valid?
      oauth_hash = OmniAuth::AuthHash.new({ info: { email: params[:email] } }.merge(session[:omniauth]))
      @user = User.find_for_oauth(oauth_hash)
    else
      @user = nil
    end
  end

  def create_omniauth_session
    session[:omniauth] = { 
      provider: params[:provider], 
      uid: params[:uid],          
      auth_token: Digest::SHA1.hexdigest([Time.now, rand].join)
    }   
  end

  def remove_omniauth_session
    session.delete(:omniauth)
  end
end