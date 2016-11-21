module Subscribed
  extend ActiveSupport::Concern

  included do
    before_action :set_subscribable, only: [:subscribe, :unsubscribe]
  end

  def unsubscribe
    current_user.unsubscribe(@subscribable)
    render json: { message: "You have successfully unsubscribed for #{@subscribable.model_name.singular}" }
  end

  def subscribe
    current_user.subscribe(@subscribable)
    render json: { message: "You have successfully subscribed for #{@subscribable.model_name.singular}" }
  end

  private

  def set_subscribable
    @subscribable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
