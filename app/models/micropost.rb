class Micropost < ActiveRecord::Base
  belongs_to :user
  scope :descending, lambda { order(id: :desc) }
  
  has_many :comments, dependent: :destroy
  
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }
    
  #  --------------- ------- Methods ------- -------------------
  def post_comment(comment_params, commenter)
    comment = comments.build(comment_params)
    comment.user = commenter
        
    if comment.save
      user.send_notification(commenter, :commented_on_post) unless user == commenter
    else
      raise Errors::FlitterError.new(I18n::t(:comment_post_error))
    end
  end
end
