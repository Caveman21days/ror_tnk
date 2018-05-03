class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: [:create]
  before_action :set_answer, except: :create
  before_action :load_question, only: :set_the_best

  after_action :publish_answer, only: [:create]

  respond_to :js

  def create
    respond_with(@answer = current_user.answers.create(answer_params.merge(question: @question)))
  end


  def update
    respond_with @answer.update(answer_params) if current_user.author_of?(@answer)
  end


  def destroy
    respond_with @answer.destroy if current_user.author_of?(@answer)
  end


  def set_the_best
    @question = @answer.question
    @answer.set_the_best if current_user.author_of?(@question)
    respond_with @answer
  end



  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def load_question
    @question = @answer.question
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
