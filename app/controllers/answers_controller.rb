class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :load_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = 'Your answer successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy 
    question = @answer.question
    if user_signed_in? && @answer.user_id == current_user.id
      @answer.destroy
      flash[:success] = 'Answer has been successfully deleted'
    end
    redirect_to question_path(question)
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
