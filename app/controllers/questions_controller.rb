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
    @answer = Answer.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      flash[:notice] = 'Question successfully deleted!'
      redirect_to root_path
    else
      flash[:notice] = 'Something gone wrong'
    end
  end




  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end
