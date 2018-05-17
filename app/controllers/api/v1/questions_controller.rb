class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: :show

  authorize_resource class: Question

  def index
    respond_with(Question.all, each_serializer: QuestionListSerializer)
  end

  def show
    respond_with @question, each_serializer: QuestionSerializer
  end

  def create
    respond_with@question = current_resource_owner.questions.create(question_params)
  end


  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find params[:id]
  end
end
