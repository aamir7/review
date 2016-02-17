class UsersController < ApplicationController
  before_action :ensure_admin, only: :destroy

  #  GET /users
  def index
    @users = User.where(admin: false).paginate(page: params[:page], :per_page => 10)
  end
    
  #  GET /users/:id
  def show
    @user = User.find_by(id: params[:id])
    if @user
      @microposts = @user.microposts.descending.paginate(page: params[:page])
    else
      redirect_user_not_found
    end
  end
  
  #  DELETE /users/:id
  def destroy
    user = User.find_by(id: params[:id])
    if user && user.destroy
      flash[:success] = t(:user_deleted)
    else
      flash[:danger]  = t(:user_delete_error)
    end
    redirect_to :back || users_path
  end
  
  #  GET /users/:id/following
  def following
    @title = t(:following_title)
    @user  = User.find(params[:id])
    if @user
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_user_not_found
    end
  end

  #  GET /users/:id/followers
  def followers
    @title = t(:follower_title)
    @user  = User.find(params[:id])
    if @user
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_user_not_found
    end
  end
  
  #  POST /users/:id/follow/:user_id
  def follow
    @user = User.find_by(id: params[:user_id])
    if @user
      current_user.follow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      redirect_user_not_found
    end

  end

  #  DELETE /users/:id/unfollow/:user_id
  def unfollow
    @user = User.find_by(id: params[:user_id])
    if @user
      current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      redirect_user_not_found
    end
  end

  #  --------------- ------- Private Methods ------- -------------------
  private
  def ensure_admin
    unless current_user.admin?
      flash[:error] = t(:authorization_error)
      redirect_to root_path
      return false
    end
  end
  
  def redirect_user_not_found
    flash[:error] = t(:user_not_found_error)
    redirect_to request.referer || root_path
  end
end
