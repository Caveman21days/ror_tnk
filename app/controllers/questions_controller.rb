class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :update, :destroy]

  after_action :publish_question, only: [:create]

  respond_to :js, only: :update

  authorize_resource



  def index
    gon.question = Question.last
    respond_with(@questions = Question.all.sorted)
  end


  def new
    respond_with(@question = Question.new)
  end


  def show
    @answer = Answer.new
    respond_with(@question)
  end


  def create
    respond_with(@question = current_user.questions.create(question_params))
  end


  def update
    @question.update(question_params)
    respond_with(@question)
  end


  def destroy
    respond_with @question.destroy
  end




  private

  def set_question
    @question = Question.find(params[:id])
  end


  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end


  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render_with_signed_in_user(
          current_user,
          json: { question: @question }
        )
    )
  end
end
