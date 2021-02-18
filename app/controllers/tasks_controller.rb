class TasksController < ApplicationController
  before_action :set_task, only: [:show]

  def index
    @tasks = Task.all
  end

  def show
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
