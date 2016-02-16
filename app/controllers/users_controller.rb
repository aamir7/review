class UsersController < ApplicationController
  before_action :authenticate_user!,  only:  [:index, :edit, :update, :destroy,
                                              :following, :followers]
  before_action :ensure_admin,        only:   :destroy

  #  GET "/users"
  def index
    @users = User.where("admin = :admin", admin: false).
                  paginate(page: params[:page], :per_page => 10)
  end
    
  #  GET "/users/9"
  def show
    @user = User.find(params[:id])
    if @user
      @microposts = @user.microposts.sort_posts.paginate(page: params[:page])
    else
      redirect_to request.referrer || users_path
    end
  end
  
  #  DELETE "/users/9"
  def destroy
    user = User.find(params[:id])
    if user
      user.destroy
      flash[:success] = t('user_deleted')
    else
      flash[:danger]  = t('user_delete_error')
    end
    redirect_to request.referrer || users_path
  end
  
  #  GET "/users/9/following"
  def following
    @title = t('following_title')
    show_follow
  end

  #  GET "/users/9/followers"
  def followers
    @title = t('follower_title')
    show_follow
  end
    
  private
    def ensure_admin
      unless current_user.admin?
        sign_out current_user
        redirect_to root_path
        return false
      end
    end
    
    def show_follow
      @user  = User.find(params[:id])
      if @user
        @users = @user.following.paginate(page: params[:page])
        render 'show_follow'
      else
        redirect_to request.referrer || users_path
      end
    end
end
