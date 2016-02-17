class Micropost < ActiveRecord::Base
  belongs_to :user
  scope :descending, lambda { order(created_at: :desc) }
  
  has_many :comments, dependent: :destroy
  
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }
    
  #  --------------- ------- Methods ------- -------------------
  def post_comment
    comment = micropost.comments.build(comment_params)
    comment.user = current_user
        
    if comment.save
      flash[:success] = t(:comment_posted)
      micropost.user.send_notification(current_user, :commented_on_post)
    else
      flash[:danger] = t(:comment_post_error)
    end
  end
end
