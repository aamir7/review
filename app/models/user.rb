class User < ActiveRecord::Base
  devise :registerable, :confirmable,  :database_authenticatable,
         :recoverable,  :rememberable, :validatable
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  has_many :microposts,     dependent:    :destroy
  has_many :notifications,  dependent:    :destroy
  
  has_many :notification_senders,   class_name:  "Notification",
                                    foreign_key: "sender_id",
                                    dependent:   :destroy
  has_many :active_relationships,   class_name:  "Relationship",
                                    foreign_key: "follower_id",
                                    dependent:   :destroy
  has_many :passive_relationships,  class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
                                    
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  before_save { self.email = email.downcase }
  
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, length: { minimum: 6 },
                       allow_nil: true
    
  def feed
    following_ids = Relationship.where("follower_id = :user_id", user_id: id).pluck(:followed_id)
    Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
                     user_id: id, following_ids: following_ids)
  end
    
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
    other_user.notifications.create(sender_id: id, notification_type: :follow)
  end
  
  def unfollow(other_user)
    relation = active_relationships.find_by(followed_id: other_user.id)
    if relation && relation.destroy
      other_user.notifications.create(sender_id: id, notification_type: :unfollow)
    end
  end
  
  def following?(other_user)
    following.include?(other_user)
  end

  def unread_notifications
    notifications.where("is_read = :is_read", is_read: false)
  end
  
  def unread_notifications_count
    notifications.where("is_read = :is_read", is_read: false).count
  end
end
