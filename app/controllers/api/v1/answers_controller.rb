class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:create]

  authorize_resource

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def index
    @answers = Answer.where(question_id: params[:question_id])
    respond_with @answers, each_serializer: AnswersSerializer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
