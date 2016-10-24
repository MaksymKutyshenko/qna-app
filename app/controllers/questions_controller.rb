class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :gon_question, only: [:show]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build  
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.create(question_params.merge(user: current_user))
    if @question.errors.blank?
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else      
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:notice] = 'Your question has been successfully updated'
      else
        flash[:alert] = 'Your question has not been updated'
      end
    else
      flash[:alert] = 'You have no rights to perform this action'
    end    
  end

  def destroy
    if current_user.author_of?(@question)
      if @question.destroy
        flash[:notice] = 'Your question has been successfully deleted!'
      else
        flash[:alert] = 'Your question has not been deleted'
      end
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
    redirect_to questions_path
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
