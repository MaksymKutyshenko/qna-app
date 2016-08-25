class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      flash[:success] = 'Your answer successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  private
  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
