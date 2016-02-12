class Notification < ActiveRecord::Base
  belongs_to :user
  default_scope lambda { order(created_at: :desc) }
    
  validates :user_id, presence: true
end
