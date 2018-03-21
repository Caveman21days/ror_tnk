class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_question
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = @question.answers
  end

  def create
    @answer = @question.answers.new(answer_params)
    flash[:notice] = if @answer.save
                       'Answer succefully created!'
                     else
                       'Something gone wrong('
                     end
    redirect_to @question
  end
  
  def edit; end

  def update; end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted!'
      redirect_to @question
    else
      flash[:danger] = 'You do not own the answer!'
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
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end
