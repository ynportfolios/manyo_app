class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'タスクを登録しました。'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクの登録に失敗しました。'
      render new_task_path
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクを編集しました。'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクの編集に失敗しました。'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_to root_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :name,
      :content
    )
  end
end
