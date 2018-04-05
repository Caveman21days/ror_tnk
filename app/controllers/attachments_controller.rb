class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :set_attachable


  def destroy
    if current_user && current_user.author_of?(@attachable)
      if @attachment.destroy
        if @attachment.get_question
          redirect_to @attachable, notice: 'File successfully deleted!'
        elsif @attachment.get_answer
          @question = @attachable.question
        end
        flash[:notice] = 'File successfully deleted!'
      else
        flash[:danger] = 'File was not deleted!'
      end
    end
  end



  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def set_attachable
    @attachable = @attachment.attachable
  end
end