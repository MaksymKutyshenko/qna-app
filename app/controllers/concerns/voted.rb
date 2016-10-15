module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:rate, :unrate]
  end

  def rate
    unless current_user.author_of?(@votable)
      @votable.rate(current_user, params[:rating])
      render json: { votable: @votable, rating: @votable.rating, message: "You have rated #{controller_name.singularize} with: #{params[:rating]}" }
    else
      render json: { errors: ["You can not rate your own #{controller_name.singularize}"] }, status: :forbidden
    end
  end

  def unrate
    if current_user.voted_for?(@votable)
      @votable.unrate(current_user)
      render json: { votable: @votable, message: 'Vote has been successfully removed', rating: @votable.rating }
    else
      render json: { errors: ['Vote can not be deleted'] }, status: :forbidden
    end
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end