class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :destroy]
  def index
    @microposts = Micropost.all
    @micropost = Micropost.new
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def create
    # @micropost = Micropost.new(micropost_params)
    # @micropost.user_id = current_user.id
    # if @micropost.save
    #   redirect_back(fallback_location: root_path)
    # else
    #   redirect_back(fallback_location: root_path)
    # end
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.user_id = current_user.id
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
