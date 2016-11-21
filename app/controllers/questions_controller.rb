class QuestionsController < ApplicationController
  include Voted
  include Subscribed

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :gon_question, only: [:show]
  before_action :build_answer, only: [:show]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with(@question)
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
    respond_with(@question)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def build_answer
    @answer = Answer.new
  end

  def gon_question
    gon.question = @question
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
