class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :set_attachable

  # я просто не могу понять, зачем тут было выносить
  # метод отдельный, мне в любом случае в зависимотси от
  # типа объекта нужно разное поведение, а из метода модели я не могу сделать редирект
  #
  # Я конечно написал метод, который вернет вопрос, но если я удаляю ответ, мне
  # не нужен редирект, мне нужен рендер js
  # Из модели я не могу делать эти проверки и мне все равно придется делать их тут

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
