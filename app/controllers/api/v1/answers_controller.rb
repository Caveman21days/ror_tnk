class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: :show
  before_action :set_question, only: :create

  authorize_resource class: Answer

  def index
    @answers = Answer.all
    respond_with @answers
  end

  def show
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)))
  end


  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find params[:question_id]
  end
end