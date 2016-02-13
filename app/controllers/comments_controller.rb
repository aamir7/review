class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
#  before_action :set_commenter, only: [:save]
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    comment = micropost.comments.build(comment_params)
    comment.user = current_user
    
    if comment.save
      flash[:success] = "Comment posted!"
    else
      flash[:danger] = "Comment not posted!"
    end
    redirect_to request.referrer || root_path
  end
  
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success] = "Comment deleted!"
    redirect_to request.referrer || root_path
  end
    
  private 
    def comment_params
      params.require(:comment).permit(:content)
    end
end
