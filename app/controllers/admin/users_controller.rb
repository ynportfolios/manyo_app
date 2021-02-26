class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    @users = User.all.includes(:tasks)
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user.id)
    else
      render :new
    end
  end
  def edit
  end
  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザを編集しました。'
      redirect_to admin_user_path(@user.id)
    else
      flash.now[:danger] = 'ユーザの編集に失敗しました。'
      render :edit
    end
  end
  def show
    @user = User.find(params[:id])
  end
  def destroy
    if @user.destroy
      flash[:success] = 'ユーザを削除しました。'
      redirect_to admin_users_path
    else
      flash[:danger] = 'ユーザの削除に失敗しました。'
      redirect_to admin_users_path
    end
  end
  private
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :admin_flg)
  end
end
