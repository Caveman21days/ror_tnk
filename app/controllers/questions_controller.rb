class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    unless current_user.nil?
      @answer = Answer.new
    end
    @answers = @question.answers
  end

  def create
    unless current_user.nil?
      @question = Question.new(question_params)
      @question.user_id = current_user.id
      if @question.save
        flash[:notice] = 'Your question successfully created'
        redirect_to @question
      else
        flash[:danger] = @question.errors.full_messages
        render :new
      end
    end
  end

  def edit; end

  def update; end

  def destroy
    if user_signed_in?
      if current_user.author_of?(@question)
        @question.destroy
        flash[:notice] = 'Question successfully deleted!'
        redirect_to questions_path
      else
        flash[:danger] = @question.errors.full_messages
        redirect_to questions_path
      end
    else
      redirect_to new_user_session_path
    end
  end





  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
