class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = @micropost.comments.page(params[:page]).per(20)
    @comment = @micropost.comments.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.user_id = current_user.id
    if @micropost.save
      flash[:success] = "投稿しました"
      redirect_to root_url
    else
      @feed_items = []
      render root_path
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
