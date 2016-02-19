class User < ActiveRecord::Base
  devise :registerable, :confirmable,  :database_authenticatable,
         :recoverable,  :rememberable, :validatable
  
  has_many :comments,       dependent:    :destroy
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
      
  #  --------------- ------- Methods ------- -------------------                  
  def feed
    res = microposts.union(
      Micropost.joins("JOIN relationships ON ((microposts.user_id = relationships.followed_id AND relationships.follower_id = #{id} ))")
    ).order(created_at: :desc)
  end
    
  def follow(other_user)
    if active_relationships.create!(followed_id: other_user.id).valid?
      other_user.send_notification(self, :followed)
    else
      raise Errors::FlitterError.new(I18n.t(:follow_error))
    end
  end
 
  
  def unfollow(other_user)
    relation = active_relationships.find_by(followed_id: other_user.id)
    if relation && relation.destroy
      other_user.send_notification(self, :unfollowed)
    else
      raise Errors::FlitterError.new(I18n.t(:unfollow_error))
    end
  end
  
#  def following?(other_user)
#    following.include?(other_user)
#  end
  
  def self.current_user=(user)
    Thread.current[:user] = user
  end
  
  def self.current_user
    Thread.current[:user]
  end
  
  def following?
    following.include?(User.current_user)
  end
  
  def followed?
    byebug
    User.current_user.following.include?(self)
  end
  
  def send_notification(sender_user, notification_type)
    notifications.create(sender_id: sender_user.id, notification_type: notification_type)
  end
end
