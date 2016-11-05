class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :best]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update  
    @answer.update(answer_params)   
    respond_with(@answer)      
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    @question = @answer.question   
    respond_with(@answer.best!)
  end

  private
  
  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "answers_for_#{@question.id}", 
      { answer: @answer.attributes.merge(attachments: @answer.attachments) }
    )
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
