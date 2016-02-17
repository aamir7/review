class CommentsController < ApplicationController
    
  # POST /microposts/:micropost_id/comments
  def create
    micropost = Micropost.find_by(id: params[:micropost_id])
    if micropost
      micropost.post_comment(comment_params)
    else
      flash[:danger] = t(:micropost_not_found_error)
    end
    redirect_to :back || root_path
  end
  
  #  DELETE /microposts/:micropost_id/comments/:id
  def destroy
    comment = Comment.find_by(id: params[:id])
    if comment && comment.destroy
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
