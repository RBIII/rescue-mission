class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
    respond_to do |format|
      format.html
      format.json { render json: @question }
    end
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Question added!'
      redirect_to @question
    else
      flash[:alert] = 'Question not added!'
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      flash[:notice] = 'Update saved!'
      redirect_to @question
    else
      flash[:alert] = 'Update not saved!'
      redirect_to edit_question_path
    end
  end

  def destroy
    id = params[:id]
    @question = Question.find(id)
    @question.destroy
    flash[:notice] = 'Question deleted.'
    redirect_to root_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :description)
  end
end
