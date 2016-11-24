class SubscribtionsController < ApplicationController
  before_action :load_question, only: [:create]
  before_action :find_subscribtion, only: [:destroy]
  respond_to :js

  authorize_resource

  def create
    respond_with(@subscribtion = current_user.subscribe(@question))
  end

  def destroy
    respond_with(@subscribtion.destroy)
  end

  private

  def find_subscribtion
    @subscribtion = Subscribtion.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
