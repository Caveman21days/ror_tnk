class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:edit, :update, :destroy]


  def create
    @answer = current_user.answers.new(answer_params.merge({ question: @question }))
    if @answer.save
      flash[:notice] = 'Your answer successfully created'
    else
      flash[:danger] = 'Your answer was not created!'
    end
  end

  def edit; end

  def update; end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted!'
      redirect_to @question
    else
      flash[:danger] = 'Your answer was not destroyed!'
      render 'questions/show'
    end
  end



  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
