class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'welcome/index'
    end
  end

  def destroy
    micropost = Micropost.find(params[:id])
    if micropost.destroy
      flash[:success] = "Micropost deleted!"
    else
      flash[:danger] = "Micropost not deleted!"
    end
    redirect_to request.referrer || root_path
  end
  
  private 
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
