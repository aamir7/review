class UsersController < ApplicationController
  load_and_authorize_resource

  #  GET /users
  def index
    @users = User.where(role: :member).paginate(page: params[:page], per_page: 3)
  end
    
  #  GET /users/:id
  def show
    @microposts = @user.microposts.descending.paginate(page: params[:page], per_page: 3)
  end
  
  #  DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t(:user_deleted)
    else
      flash.now[:danger]  = t(:user_delete_error)
    end
    redirect_to :back || users_path # two paths i.e. from user list or from following/follower list
  end
  
  #  GET /users/:id/following
  def following
    @title = t(:following_title)
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  #  GET /users/:id/followers
  def followers
    @title = t(:follower_title)
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  #  POST /users/:id/follow
  def follow
    current_user.follow(@user)
    respond_to do |format|
      format.js
    end
  end

  #  DELETE /users/:id/unfollow
  def unfollow
   current_user.unfollow(@user)       
    respond_to do |format|
      format.js
    end
  end
end
