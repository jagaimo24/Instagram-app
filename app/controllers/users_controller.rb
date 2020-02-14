class UsersController < ApplicationController
  before_action :admin_user,     only: :destroy

  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    @user  = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page]).per(20)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました"
    redirect_to users_url
  end

  private
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
