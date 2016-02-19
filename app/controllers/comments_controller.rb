class CommentsController < ApplicationController
  load_and_authorize_resource :micropost
  load_and_authorize_resource :comment, through: :micropost
  
  # POST /microposts/:micropost_id/comments
  def create
    micropost = Micropost.find_by(id: params[:micropost_id])
    if micropost
      micropost.post_comment(comment_params, current_user)
      flash[:success] = I18n::t(:comment_posted)
    else
      flash[:danger] = t(:micropost_not_found_error)
    end
    redirect_to :back || root_path
  end
  
  #  DELETE /microposts/:micropost_id/comments/:id
  def destroy
    if @comment && @comment.destroy
      flash[:success] = t(:comment_deleted)
    else
      flash[:danger] = t(:comment_delete_error)
    end
    redirect_to :back || root_path
  end
    
  #  --------------- ------- Private Methods ------- -------------------
  private 
  def comment_params
    params.require(:comment).permit(:content)
  end
end
