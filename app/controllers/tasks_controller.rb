class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if params[:sort_expired]
      @tasks = Task.all.order("deadline DESC")
    elsif params[:name] && params[:status] && !(params[:status] == 'なし') && !(params[:name] == '')
      @tasks = Task.search_name_status(params[:name], params[:status])
    elsif params[:name] && (params[:status] == 'なし') && !(params[:name] == '')
      @tasks = Task.search_name(params[:name])
    elsif params[:status] && (params[:status] != 'なし') && (params[:name] == '')
      @tasks = Task.search_status(params[:status])
    else
      @tasks = Task.all.order("created_at DESC")
    end
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
      :content,
      :deadline,
      :status
    )
  end
end
