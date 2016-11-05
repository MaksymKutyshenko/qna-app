module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:rate, :unrate]
  end

  def rate
    authorize! :rate, @votable
    @votable.rate(current_user, params[:rating])
    render json: { votable: @votable, rating: @votable.rating, message: "You have rated #{controller_name.singularize} with: #{params[:rating]}" }
  end

  def unrate
    authorize! :unrate, @votable
    @votable.unrate(current_user)
    render json: { votable: @votable, message: 'Vote has been successfully removed', rating: @votable.rating }
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end