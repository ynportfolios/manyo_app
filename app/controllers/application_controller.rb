class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :current_user

  before_action :authenticate_user, if: proc { !((controller_path == 'users' && action_name == 'new') ||
                                                (controller_path == 'sessions' && action_name == 'new') ||
                                                (controller_path == 'users' && action_name == 'create') ||
                                                (controller_path == 'sessions' && action_name == 'create')) }

  before_action :not_authenticate_user, if: proc { controller_path == 'users' && action_name == 'new' }

  def authenticate_user
    # 現在ログイン中のユーザが存在しない場合、ログインページにリダイレクトさせる。
    if @current_user == nil
      flash[:danger] = 'ログインしてください'
      redirect_to new_session_path
    end
  end

  def not_authenticate_user
    # 現在ログイン中のユーザが存在しない場合、ログインページにリダイレクトさせる。
    if @current_user != nil
      flash[:danger] = 'ログアウトしてください'
      redirect_to user_path(@current_user.id)
    end
  end
end
