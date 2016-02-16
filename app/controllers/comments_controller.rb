class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
    
  # POST "/microposts/20/comments"
  def create
    micropost = Micropost.find(params[:micropost_id])
    if micropost
      comment = micropost.comments.build(comment_params)
      comment.user = current_user
    
      if comment.save
        flash[:success] = t('comment_posted')
        micropost.user.notifications.create(sender_id: current_user.id, notification_type: :comment)
      else
        flash[:danger] = t('comment_post_error')
      end
    else
      flash[:danger] = t('micropost_not_found_error')
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
