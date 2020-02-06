class CommentsController < ApplicationController
  load_and_authorize_resource :micropost
  load_and_authorize_resource :comment, through: :micropost
  
  # POST /microposts/:micropost_id/comments
  def create
    micropost = Micropost.find_by(id: params[:micropost_id])
    if micropost.present?
      @micropost.post_comment(comment_params, current_user)
      flash[:success] = I18n::t(:comment_posted)
      redirect_to :back || user_root_path #comment can be from feed or from user profile so redirect and show updated
    else
      flash[:danger] = t(:micropost_not_found_error)
      respond_to do |format|
        format.html { render "home/index" }
      end
    end
  end
  
  #  DELETE /microposts/:micropost_id/comments/:id
  def destroy
    if @comment.present? && @comment.destroy
      flash[:success] = t(:comment_deleted)
      redirect_to :back || user_root_path #delete from feed page or user profile page
    else
      flash[:danger] = t(:comment_delete_error)
      respond_to do |format|
        format.html { render "home/index" }
      end
    end
  end
    
  #  --------------- ------- Private Methods ------- -------------------
  private 
  def comment_params
    params.require(:comment).permit(:content)
  end
end
