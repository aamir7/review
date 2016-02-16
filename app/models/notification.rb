class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification_senders, class_name: "User"
  
  scope :sort_notifications,    lambda { order(created_at:  :desc) }
  scope :unread_notifications,  lambda { where(is_read:     false) }
    
  validates :user_id, presence: true
end
