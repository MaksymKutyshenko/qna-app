class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    if current_user.author_of?(@attachment.attachable)
      respond_with(@attachment.destroy)
    else
      flash[:alert] = 'You have no rights to perform this action'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end