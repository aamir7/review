class UsersController < ApplicationController
  before_action :authenticate_user!,  only:  [:index, :edit, :update, :destroy,
                                              :following, :followers]
  before_action :ensure_admin!,       only:   :destroy

  def index
    @users = User.where("admin = :admin", admin: false).
                  paginate(page: params[:page], :per_page => 10)
  end
    
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
    
  private
    def ensure_admin!
      unless current_user.admin?
        sign_out current_user
        redirect_to root_path
        return false
      end
    end
end
