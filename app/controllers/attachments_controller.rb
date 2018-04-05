class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :set_attachable


#Как по мне - так это крайне костыльно. Но, вроде,
#
  def destroy
    if current_user && current_user.author_of?(@attachable)
      if @attachment.destroy
        if @attachable.class.name == 'Question'
          redirect_to @attachable, notice: 'File successfully deleted!'
        elsif @attachable.class.name == 'Answer'
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