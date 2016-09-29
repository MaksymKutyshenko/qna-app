class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash[:notice] = 'Attachment has been successfully deleted'
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
  end
end