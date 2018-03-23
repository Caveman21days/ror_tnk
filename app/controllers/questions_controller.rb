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
    if current_user
      @answer = Answer.new
    end
    @answers = @question.answers
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      flash[:danger] = 'Your question was not created!'
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question successfully deleted!'
    else
      flash[:danger] = 'Your question was not deleted!'
    end
    redirect_to questions_path
  end





  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
