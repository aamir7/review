class UsersController < ApplicationController
  before_action :authenticate_user!,  only:  [:index, :edit, :update, :destroy,
                                              :following, :followers]
  before_action :ensure_admin,       only:   :destroy

  def index
    @users = User.where("admin = :admin", admin: false).
                  paginate(page: params[:page], :per_page => 10)
  end
    
  def show
    @user = User.find(params[:id])
    if @user
      @microposts = @user.microposts.paginate(page: params[:page])
    else
      redirect_to request.referrer || users_path
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if user
      user.destroy
      flash[:success] = "User deleted!"
    else
      flash[:danger]  = "User not deleted!"
    end
    redirect_to request.referrer || users_path
  end
  
  def following
    @title = "Following"
    show_follow
  end

  def followers
    @title = "Followers"
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
