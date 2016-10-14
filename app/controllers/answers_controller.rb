class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :best]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    if @answer.errors.blank?
      flash[:notice] = 'Your answer successfully created'
    end
  end

  def update  
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Answer has been successfully updated'
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      if @answer.destroy
        flash[:notice] = 'Answer has been successfully deleted'
      else
        flash[:alert] = 'Answer has not been deleted'
      end
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.best!
      flash[:notice] = 'Best answer chosen!'
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
  end

  private
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
