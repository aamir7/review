class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
    
  # POST "/microposts/20/comments"
  def create
    micropost = Micropost.find(params[:micropost_id])
    comment = micropost.comments.build(comment_params)
    comment.user = current_user
    
    if comment.save
      flash[:success] = t('comment_posted')
    else
      flash[:danger] = t('comment_post_error')
    end
    redirect_to request.referrer || root_path
  end
  
  #  DELETE "/microposts/20/comments/29"
  def destroy
    comment = Comment.find(params[:id])
    if comment && comment.destroy
      flash[:success] = t('comment_deleted')
    else
      flash[:danger] = t('comment_delete_error')
    end
    redirect_to request.referrer || root_path
  end
    
  private 
    def comment_params
      params.require(:comment).permit(:content)
    end
end
