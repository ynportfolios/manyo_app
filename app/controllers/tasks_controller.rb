class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  PER = 3

  def index
    if params[:label_id]
      @tasks = @current_user.tasks.joins(:labels).where(labels: { id: params[:label_id] }).page(params[:page]).per(PER)
    elsif params[:sort_expired]
      @tasks = @current_user.tasks.order("deadline DESC").page(params[:page]).per(PER)
    elsif params[:sort_priority]
      @tasks = @current_user.tasks.order("priority DESC").page(params[:page]).per(PER)
    elsif params[:name] && params[:status] && !(params[:status] == 'なし') && !(params[:name] == '')
      @tasks = @current_user.tasks.search_name_status(params[:name], params[:status]).page(params[:page]).per(PER)
    elsif params[:name] && (params[:status] == 'なし') && !(params[:name] == '')
      @tasks = @current_user.tasks.search_name(params[:name]).page(params[:page]).per(PER)
    elsif params[:status] && (params[:status] != 'なし') && (params[:name] == '')
      @tasks = @current_user.tasks.search_status(params[:status]).page(params[:page]).per(PER)
    else
      @tasks = @current_user.tasks.order("created_at DESC").page(params[:page]).per(PER)
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
    redirect_to tasks_path
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
      :status,
      :priority,
      :user_id, 
      { label_ids: [] }
    )
  end
end
