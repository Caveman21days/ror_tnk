class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, except: :create
  after_action :publish_answer, only: [:create]

  def create
    @answer = current_user.answers.new(answer_params.merge({ question: @question }))
    if @answer.save
      flash[:notice] = 'Your answer successfully created'
    else
      flash[:danger] = 'Your answer was not created!'
    end
  end


  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Your answer successfully edited!'
    else
      flash[:danger] = 'You are not owner of answer!'
    end
  end


  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted!'
    else
      flash[:danger] = 'Your answer was not destroyed!'
    end
  end


  def set_the_best
    @question = @answer.question
    @answer.set_the_best if current_user.author_of?(@question)
  end



  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
        "answers_#{@question.id}",
        ApplicationController.render_with_signed_in_user(
            current_user,
            json: { answer: @answer,
                    author_of_answer: @answer.user,
                    attachments: @answer.attachments }
        )
    )
  end
end
