class MemberAbility < Ability

  def initialize(user)
    can :read,  User
    can :follow, User, followed?: false
    can :unfollow, User, followed?: true
    can [:followers, :following], User, id: user.id
      
    can :read,  [Micropost, Comment]
    can [:destroy],  Comment, user_id: user.id
    can [:create, :destroy],  Micropost, user_id: user.id
    
#    can :post_comment, Post do |p|
#      user.following.include?(p.user)
#    end
#    byebug
    can :create, Comment, micropost: { user_id: user.following_ids << user.id }
#      byebug
#      
#    can :create, Comment do |c|
#      byebug
#      user.following.include?(c.micropost.user)
#    end
  end
end