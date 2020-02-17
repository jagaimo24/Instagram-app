class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:following, :followers]
  before_action :admin_user,         only: :destroy

  def index
    @users = User.page(params[:page]).per(20).search(params[:search])
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

  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(20)
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(20)
    render 'show_follow'
  end

  private
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
