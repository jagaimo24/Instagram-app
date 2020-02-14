class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  def index
    @microposts = Micropost.all
    @micropost = Micropost.new
  end

  def show
    @micropost = Micropost.find(params[:id])
  end

  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user_id = current_user.id
    if @micropost.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
