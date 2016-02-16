class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  # POST "/microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t('micropost_posted')
      redirect_to root_path
    else
      flash[:danger] = t('micropost_post_error')
      render 'welcome/index'
    end
  end

  #  DELETE "/microposts/20"
  def destroy
    micropost = Micropost.find(params[:id])
    if micropost.destroy
      flash[:success] = t('micropost_deleted')
    else
      flash[:danger] = t('micropost_delete_error')
    end
    redirect_to request.referrer || root_path
  end
  
  private 
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
