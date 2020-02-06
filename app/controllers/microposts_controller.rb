class MicropostsController < ApplicationController
  load_and_authorize_resource

  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t(:micropost_posted)
      redirect_to user_root_path #feed_items need so can't just render page
    else
      flash[:danger] = t(:micropost_post_error)
      respond_to do |format|
        format.html { render "home/index" }
      end
    end
  end

  #  DELETE /microposts/:id
  def destroy
    if @micropost.present? && @micropost.destroy
      flash[:success] = t(:micropost_deleted)
      redirect_to user_root_path #feed_items need so can't just render page
    else
      flash[:danger] = t(:micropost_delete_error)
      respond_to do |format|
        format.html { render "home/index" }
      end 
    end
  end
  
  #  --------------- ------- Private Methods ------- -------------------
  private 
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
