class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]
  after_action :publish_comment, only: [:create]

  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(commet_params.merge(user: current_user)))
  end

  private

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def publish_comment 
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments", 
      comment: @comment
    ) 
  end

  def commet_params
    params.require(:comment).permit(:body)
  end
end