class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :load_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = 'Your answer successfully created'
    else
      flash[:danger] = @answer.errors.full_messages.to_sentence
    end
    redirect_to @question
  end

  def destroy 
    question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = 'Answer has been successfully deleted'
    else
      flash[:danger] = 'You have no rights to perform this action'
    end
    redirect_to question
  end

  private
  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
