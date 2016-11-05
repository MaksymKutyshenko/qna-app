require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :js

  protect_from_forgery with: :exception
  
  before_action :gon_user, unless: :devise_controller?
  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { render 'shared/access_denied', status: :forbidden }
      format.json { render json: { errors: ['You have no rights to perform this action'] }, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  private
  def gon_user
    gon.user_id = current_user.try(:id)
  end
end
