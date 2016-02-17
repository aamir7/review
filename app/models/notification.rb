class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :sender, class_name: "User"
  
  default_scope   lambda { order(created_at: :desc) }
  scope :unread,  lambda { where(is_read: false) }
    
  validates :user,    presence: true
  validates :sender,  presence: true
end
