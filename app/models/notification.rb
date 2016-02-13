class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification_senders, class_name: "User"
  
  default_scope lambda { order(created_at: :desc) }
    
  validates :user_id, presence: true
end
