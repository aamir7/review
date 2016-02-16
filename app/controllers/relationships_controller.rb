class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  #  POST "/relationships"
  def create
    @user = User.find_by(id: params[:followed_id])
    if @user
      current_user.follow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      redirect_to request.referrer || root_path
    end
    
  end
  
  #  DELETE "/relationships/20"
  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user
      current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      redirect_to request.referrer || root_path
    end
  end
end
