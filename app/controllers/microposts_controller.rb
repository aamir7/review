class MicropostsController < ApplicationController
  load_and_authorize_resource
  
  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t(:micropost_posted)
      redirect_to root_path #to show updated post
    else
      flash[:danger] = t(:micropost_post_error)
      render 'welcome/index'
    end
  end

  #  DELETE /microposts/:id
  def destroy
    if @micropost && @micropost.destroy
      flash[:success] = t(:micropost_deleted)
    else
      flash[:danger] = t(:micropost_delete_error)
    end
    redirect_to root_path
  end
  
  #  --------------- ------- Private Methods ------- -------------------
  private 
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
