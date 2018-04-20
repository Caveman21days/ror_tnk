class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :set_attachable


  def destroy
    if current_user && current_user.author_of?(@attachable)
      if @attachment.destroy

        if @attachable.class.name == 'Question'
          redirect_to @attachment.question, notice: 'File successfully deleted!'
        elsif @attachable.class.name == 'Answer'
          @question = @attachment.question
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
