class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, only: [:edit, :update, :destroy]


  def create
    if user_signed_in?
      @answer = Answer.new(answer_params.merge({ user_id: current_user.id, question_id: @question.id }))
      if @answer.save
        flash[:notice] = 'Your answer successfully created'
        redirect_to @question
      else
        flash[:danger] = @answer.errors.full_messages
        render 'questions/show'
      end
    end
  end

  def edit; end

  def update; end

  def destroy
    if user_signed_in?
      if current_user.author_of?(@answer)
        @answer.destroy
        flash[:notice] = 'Your answer successfully deleted!'
        redirect_to @question
      else
        flash[:danger] = @answer.errors.full_messages
        render 'questions/show'
      end
    else
      redirect_to new_user_session_path
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
