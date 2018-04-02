class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:update, :destroy, :set_the_best]


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
    params.require(:answer).permit(:body)
  end
end
